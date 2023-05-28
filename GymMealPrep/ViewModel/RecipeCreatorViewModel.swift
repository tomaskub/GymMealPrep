//
//  RecipeCreatorViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/27/23.
//

import Foundation
import Combine

/// This class is a protocol definition for view model of RecipeCreatorViews
class RecipeCreatorViewModelProtocol: ObservableObject {
    
    // input properties
    @Published var ingredientsEntry: String = String()
    @Published var instructionsEntry: String = String()
    
    // input processed properties
    @Published var ingredientsNLArray: [String] = []
    
    // output properties
    @Published var parsedIngredients = [String : [[Ingredient]]]()
    @Published var parsedInstructions: [Instruction] = []
    
    
    func processInput() {
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
        
        // remove data from previous calls
        ingredientsNLArray = [String]()
        parsedIngredients = [String : [[Ingredient]]]()
        parsedInstructions = [Instruction]()
        
        // process ingredients entry into array of natural language ingredients for use with edamam parser
        ingredientsNLArray = ingredientsEntry.components(separatedBy: .newlines)
        
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
                }
                .store(in: &subscriptions)
        }
    }
}
