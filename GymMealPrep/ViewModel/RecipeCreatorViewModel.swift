//
//  RecipeCreatorViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/27/23.
//

import Foundation
import Combine

class RecipeCreatorViewModel: ObservableObject {
    
    @Published var ingredientsEntry: String
    @Published var instructionsEntry: String
    @Published var parsed: [EdamamParserResponse]
    @Published var ingredientsNLArray: [String]
    
    var subscriptions = Set<AnyCancellable>()
    let edamamLogicController: EdamamLogicControllerProtocol = EdamamLogicController(networkController: NetworkController())
    
    init() {
        self.ingredientsEntry = String()
        self.instructionsEntry = String()
        self.ingredientsNLArray = [String]()
        self.parsed = [EdamamParserResponse]()
    }
    
    func processInput() {
        // create natural language array of ingredients to use with edamam parser
        ingredientsNLArray = ingredientsEntry.components(separatedBy: .newlines)
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
    }
}
