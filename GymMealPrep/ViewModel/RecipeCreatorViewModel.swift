//
//  RecipeCreatorViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/27/23.
//

import Foundation
import Combine

/// This class is a protocol definition for view model of RecipeCreatorViews
class RecipeCreatorViewModelProtocol: ObservableObject, IngredientSaveHandler {
    
    // input properties
    @Published var ingredientsEntry: String = String()
    @Published var instructionsEntry: String = String()
    
    // input processed properties
    @Published var ingredientsNLArray: [String] = []
    var instructionsNLArray: [String] = []
    
    // output properties
    @Published var parsedIngredients = [String : [[Ingredient]]]()
    @Published var matchedIngredients = [String : Ingredient]()
    @Published var parsedInstructions: [Instruction] = []
    
    
    func processInput() {
        assertionFailure("Missing override: Please override this method in the subclass")
    }
    
    func addIngredient(_: Ingredient, _: String?) {
            assertionFailure("Missing override: Please override this method in the subclass")
    }
}

class RecipeCreatorViewModel: RecipeCreatorViewModelProtocol {
    
    
    
    var subscriptions = Set<AnyCancellable>()
    let edamamLogicController: EdamamLogicControllerProtocol = EdamamLogicController(networkController: NetworkController())
    
    override init() {
        super.init()
        self.ingredientsNLArray = [String]()
        self.ingredientsEntry = String()
        self.instructionsEntry = String()
        
        
    }
    
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
           edamamLogicController.getIngredients(for: searchTerm)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Completed edamam API request with success for \(searchTerm)")
                    case .failure(let error):
                        print("Error requesting response for \(searchTerm). Error: \(error) - \(error.localizedDescription)")
                    }
                } receiveValue: { [weak self] data in
                    guard let self else { return }
                    self.parsedIngredients.updateValue(data, forKey: searchTerm)
                    if let bestMatch = data.first?.first {
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
                if character.isNumber {
                    let instructionToAppend = Instruction(step: index + 1, text: instructionText)
                    parsedInstructions.append(instructionToAppend)
                } else {
                    if index - 1 >= 0 {
                        parsedInstructions[index-1].text.append(instructionText)
                    } else {
                        let instructionToAppend = Instruction(step: index + 1, text: instructionText)
                    }
                    
                }
            }
        }
    }
    override func addIngredient(_ ingredientToSave: Ingredient, _ key: String?) {
        if let key {
            matchedIngredients.updateValue(ingredientToSave, forKey: key)
        }
    }
    
}

