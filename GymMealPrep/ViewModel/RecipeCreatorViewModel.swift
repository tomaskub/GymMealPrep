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
    // output properties
    @Published var parsedIngredients = [(String, [Ingredient])]()
    @Published var parsedInstructions: [Instruction] = []
    
    func processInput() {
        assertionFailure("Missing override: Please override this method in the subclass")
    }
    
}

class RecipeCreatorViewModel: RecipeCreatorViewModelProtocol {
    
    @Published var ingredientsNLArray: [String]
    
    var subscriptions = Set<AnyCancellable>()
    let edamamLogicController: EdamamLogicControllerProtocol = EdamamLogicController(networkController: NetworkController())
    
    override init() {
        self.ingredientsNLArray = [String]()
        super.init()
        self.ingredientsEntry = String()
        self.instructionsEntry = String()
        
        
    }
    
    override func processInput() {
        // create natural language array of ingredients to use with edamam parser
        guard !ingredientsEntry.isEmpty else { return }
        ingredientsNLArray = ingredientsEntry.components(separatedBy: .newlines)
        // former implementation based on parsed response
        /*
        for searchTerm in ingredientsNLArray {
            edamamLogicController.getIngredients(for: searchTerm)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    print(completion)
                } receiveValue: { [weak self] response in
                    guard let self else { return }
                    self.parsed.append(response)
                }
                .store(in: &subscriptions)
        }
         */
        
        
    }
}
