//
//  RecipeCreatorViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/27/23.
//

import Foundation
import Combine
import PhotosUI
import SwiftUI
import UIKit

/// This class is a protocol definition for view model of RecipeCreatorViews
class RecipeCreatorViewModelProtocol: ObservableObject, IngredientSaveHandler {
    
    // input properties
    @Published var recipeTitle: String = String()
    @Published var ingredientsEntry: String = String()
    @Published var instructionsEntry: String = String()
    
    @Published var timePreparingInMinutes: String = String()
    @Published var timeCookingInMinutes: String = String()
    @Published var timeWaitingInMinutes: String = String()
    @Published var tagText: String = String()
    @Published var servings: Int = 1
    // image input
    @Published var selectedImage: PhotosPickerItem?
    // input processed properties
    @Published var ingredientsNLArray: [String] = []
    var instructionsNLArray: [String] = []
    
    // output properties
    @Published var parsedIngredients = [String : [[Ingredient]]]()
    @Published var matchedIngredients = [String : Ingredient]()
    @Published var parsedInstructions: [Instruction] = []
    @Published var tags: [Tag] = []
    @Published var recipeImage: Image?
    
    // alert properties
    @Published var isShowingAlert: Bool = false
    var alertTitle: String = String()
    var alertMessage: String = String()
    
    func processInput() {
        assertionFailure("Missing override: Please override this method in the subclass")
    }
    
    func addIngredient(_: Ingredient, _: String?) {
        assertionFailure("Missing override: Please override this method in the subclass")
    }
    func saveRecipe() -> Recipe {
        assertionFailure("Missing override: Please override this method in the subclass")
        return Recipe()
    }
    func createRecipeViewModel() -> RecipeViewModel {
        assertionFailure("Missing override: Please override this method in the subclass")
        return RecipeViewModel(recipe: Recipe())
    }
    func addTag() {
        assertionFailure("Missing override: Please override this method in the subclass")
    }
    
    func deleteInstruction(at offset: IndexSet) {
        assertionFailure("Missing override: Please override this method in the subclass")
    }
    func moveInstruction(fromOffset source: IndexSet, toOffset destination: Int) {
        assertionFailure("Missing override: Please override this method in the subclass")
    }
    func addInstruction() {
        assertionFailure("Missing override: Please override this method in the subclass")
    }
    func deletePhoto() {
        assertionFailure("Missing override: Please override this method in the subclass")
    }
    func clearAlertMessage() {
        alertTitle = String()
        alertMessage = String()
    }
}

class RecipeCreatorViewModel: RecipeCreatorViewModelProtocol {
    private var dataManager: DataManager
    var subscriptions = Set<AnyCancellable>()
    var recipeImageData: Data? {
        didSet {
            if let data = recipeImageData, let uiImage = UIImage(data: data) {
                recipeImage = Image(uiImage: uiImage)
            } else {
                recipeImage = nil
            }
        }
    }
    let edamamLogicController: EdamamLogicControllerProtocol = EdamamLogicController(networkController: NetworkController())
    
    override var selectedImage: PhotosPickerItem? {
        didSet {
            // this needs to change
                Task { @MainActor in
                    recipeImageData = await loadPhoto(from: selectedImage)
//                        recipeImage = try await selectedImage?.loadTransferable(type: Image.self)
                }
        }
    }
    func loadPhoto(from imageSelection: PhotosPickerItem?) async -> Data? {
        do {
            if let data = try await imageSelection?.loadTransferable(type: Data.self) {
                if let _ = UIImage(data: data) {
                    return data
                }
            }
            return nil
        } catch {
            print("Error loading photo: \(error.localizedDescription)")
            return nil
        }
    }
    override func deletePhoto() {
        recipeImageData = nil
    }
    
    init(dataManager: DataManager = .shared) {
        self.dataManager = dataManager
        super.init()
        self.ingredientsNLArray = [String]()
        self.ingredientsEntry = String()
        self.instructionsEntry = String()
    }
    //TODO: REWORK THE GUARD STATEMENT AND PARSING INSTRUCTIONS (SEPERATE TO PARSER CLASS)
    override func processInput() {
        // check if there is ingredient input, otherwise return
        guard !ingredientsEntry.isEmpty else { return }
        parseIngredients(input: ingredientsEntry)
        parseInstructions(input: instructionsEntry)
    }
    
    func parseIngredients(input: String) {
        // remove data from previous calls
        ingredientsNLArray = [String]()
        parsedIngredients = [String : [[Ingredient]]]()
        matchedIngredients = [String : Ingredient]()
        
        
        // process ingredients entry into array of natural language ingredients for use with edamam parser
        ingredientsNLArray = input.components(separatedBy: .newlines)
        
        // send request for matching ingredients to EdamamAPI
        for searchTerm in ingredientsNLArray {
           edamamLogicController.getIngredientsWithParsed(for: searchTerm)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Completed edamam API request with success for \(searchTerm)")
                    case .failure(let error):
                        print("Error requesting response for \(searchTerm). Error: \(error) - \(error.localizedDescription)")
                    }
                } receiveValue: { [weak self] (data, parsed) in
                    guard let self else { return }
                    self.parsedIngredients.updateValue(data, forKey: searchTerm)
                    if let bestMatch = parsed {
                        self.matchedIngredients.updateValue(bestMatch, forKey: searchTerm)
                    }
                }
                .store(in: &subscriptions)
        }
    }
    //add a function to figure out the beging of the instruction (number, dash etc)
    func parseInstructions(input: String) {
        //Reset any remeaing data from previous parsing
        instructionsNLArray = [String]()
        parsedInstructions = [Instruction]()
        
        // seperate entry string into components
        instructionsNLArray = input.components(separatedBy: .newlines)
        
        
        for (index, instructionText) in instructionsNLArray.enumerated() {
            
            if let character = instructionText.first {
                if character.isNumber || character.isSymbol || parsedInstructions.isEmpty {
                    var text = instructionText
                    while (text.first?.isNumber ?? false || text.first?.isSymbol ?? false || text.first?.isPunctuation ?? false || text.first?.isWhitespace ?? false) {
                        text = String(text.dropFirst())
                    }
                    let instructionToAppend = Instruction(step: index + 1, text: text)
                    parsedInstructions.append(instructionToAppend)
                } else {
                    if index - 2 >= 0 {
                        parsedInstructions[index-2].text.append(instructionText)
                    } else {
                        let instructionToAppend = Instruction(step: index + 1, text: instructionText)
                    }
                }
            }
        }
    }
    
    override func saveRecipe() -> Recipe {
        
        var recipe = Recipe(
            name: recipeTitle,
            servings: servings,
            timeCookingInMinutes: Int(timeCookingInMinutes) ?? 0,
            timePreparingInMinutes: Int(timePreparingInMinutes) ?? 0,
            timeWaitingInMinutes: Int(timeWaitingInMinutes) ?? 0,
            ingredients: Array(matchedIngredients.values),
            instructions: parsedInstructions,
            tags: tags)
        if let recipeImageData {
            recipe.imageData = recipeImageData
        }
        
        dataManager.updateAndSave(recipe: recipe)
        return recipe
    }
    
    override func createRecipeViewModel() -> RecipeViewModel {
        return RecipeViewModel(recipe:
        Recipe(name: recipeTitle, servings: 1, timeCookingInMinutes: 0, timePreparingInMinutes: 0, timeWaitingInMinutes: 0, ingredients: [], instructions: [], tags: []))
    }
    
    override func addTag() {
        tags.append(Tag(text: tagText))
        tagText = String()
    }
    
    override func addIngredient(_ ingredientToSave: Ingredient, _ key: String?) {
        if let key {
            matchedIngredients.updateValue(ingredientToSave, forKey: key)
        }
    }
    override func deleteInstruction(at offset: IndexSet) {
        parsedInstructions.remove(atOffsets: offset)
    }
    override func moveInstruction(fromOffset source: IndexSet, toOffset destination: Int) {
        parsedInstructions.move(fromOffsets: source, toOffset: destination)
    }
    override func addInstruction() {
        parsedInstructions.append(Instruction(step: parsedInstructions.count + 1))
    }
}

