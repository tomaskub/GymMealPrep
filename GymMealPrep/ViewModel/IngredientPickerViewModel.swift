//
//  IngredientPickerViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/16/23.
//

import Foundation
import Combine

class IngredientPickerViewModel: ObservableObject {
    
    var subscriptions = Set<AnyCancellable>()
    let edamamLogicController: EdamamLogicController = EdamamLogicController(networkController: NetworkController())
    
    @Published var ingredients: [EdamamParserResponse.EdamamFood] = []
    @Published var searchTerm: String = String()
    
    func searchForIngredient() {
        
        if !searchTerm.isEmpty {
            edamamLogicController.getIngredients(for: searchTerm)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    print(completion)
                } receiveValue: { [weak self] response in
                    //assign values to a holder that can be used by the view
                    guard let self else { return }
                    self.ingredients = []
                    if let parsedFood = response.parsed.first?.food {
                        self.ingredients.append(parsedFood)
                    }
                    for hint in response.hints {
                        self.ingredients.append(hint.food)
                    }
                }
                .store(in: &subscriptions)
        }
    }
}
