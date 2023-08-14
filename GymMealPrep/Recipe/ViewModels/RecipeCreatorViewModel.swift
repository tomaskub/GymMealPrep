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

class RecipeCreatorViewModel: RecipeCreatorViewModelProtocol {
    private var recipeImageData: Data?
    private var dataManager: DataManager
    private var subscriptions = Set<AnyCancellable>()
    let networkController: NetworkController
    let edamamLogicController: EdamamLogicControllerProtocol
    let webLinkLogicController: WebLinkLogicController
    
    init(dataManager: DataManager = .shared) {
        self.dataManager = dataManager
        self.networkController = NetworkController()
        self.edamamLogicController = EdamamLogicController(networkController: networkController)
        self.webLinkLogicController = WebLinkLogicController(networkController: networkController)
        super.init()
        self.ingredientsNLArray = [String]()
        self.ingredientsEntry = String()
        self.instructionsEntry = String()
    }
    
    override func processLink() {
        //TODO: ADD IMPLEMENTATION
        guard let url = URL(string: recipeLink) else {
            alertTitle = "Cannot load the link"
            alertMessage = "The recipe link provided was not valid"
            isShowingAlert.toggle()
            return
        }
        self.webLinkLogicController.getData(for: recipeLink)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.alertTitle = "Error while downloading the recipe"
                    self?.alertMessage = "\(error.localizedDescription)"
                    self?.isShowingAlert.toggle()
                    return
                case .finished:
                    print("Network request for data finished with success")
                }
            } receiveValue: { [weak self] data in
                if let value = try? NSAttributedString(data: data, options: [
                        .documentType: NSAttributedString.DocumentType.html,
                        .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) {
                    
                    // Parsing takes place here:
                    let parser = WebsiteRecipeParserEngine(source: value.string)
                    let (scannedIngredients, scannedInstructions) = parser.scanForRecipeData()
                    let reduceClosure: (String, String) -> String = { first, second in
                        if first.isEmpty {
                            return second
                        }
                        return "\(first)\n\(second)"
                    }
                    self?.ingredientsEntry = scannedIngredients.reduce("", reduceClosure)
                    self?.instructionsEntry = scannedInstructions.reduce("", reduceClosure)
                    
                } else {
                    self?.alertTitle = "Cannot parse recipe from the link"
                    self?.alertMessage = "The retrived recipe failed to parse, please continue and enter the ingredients and instructions manually"
                    self?.isShowingAlert.toggle()
                }
            }
            .store(in: &subscriptions)
        

        //do the download and parsing
    }
    //TODO: REWORK THE GUARD STATEMENT AND PARSING INSTRUCTIONS (SEPERATE TO PARSER CLASS)
    override func processInput() {
        // check if there is ingredient input, otherwise return
        guard !ingredientsEntry.isEmpty else {
            alertTitle = "Cannot create recipe"
            alertMessage = "The recipe cannot be created without ingredients! To proceed please add ingredients"
            isShowingAlert.toggle()
            return
        }
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
    
    override func addTag() {
        tags.append(Tag(text: tagText))
        tagText = String()
    }
    //MARK: INGREDIENT FUNCTIONS
    override func addIngredient(_ ingredientToSave: Ingredient, _ key: String?) {
        if let key {
            matchedIngredients.updateValue(ingredientToSave, forKey: key)
        }
    }
    
    //MARK: INSTRUCTION FUNCTIONS
    override func deleteInstruction(at offset: IndexSet) {
        parsedInstructions.remove(atOffsets: offset)
    }
    
    override func moveInstruction(fromOffset source: IndexSet, toOffset destination: Int) {
        parsedInstructions.move(fromOffsets: source, toOffset: destination)
        for (index, instruction) in parsedInstructions.enumerated() {
            let targetInstruction = Instruction(id: instruction.id, step: index + 1, text: instruction.text)
            parsedInstructions[index] = targetInstruction
        }
    }
    
    override func addInstruction() {
        parsedInstructions.append(Instruction(step: parsedInstructions.count + 1))
    }
    override func addImageData(data: Data) {
        recipeImageData = data
    }
    override func deleteImageData() {
        recipeImageData = nil
    }
}

