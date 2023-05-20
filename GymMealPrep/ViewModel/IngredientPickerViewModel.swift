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
    
    @Published var ingredientsRow: [[Ingredient]] = [[]]
    @Published var searchTerm: String = String()
    
    func searchForIngredient() {
        
        if !searchTerm.isEmpty {
            edamamLogicController.getIngredients(for: searchTerm)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    print(completion)
                } receiveValue: { [weak self] result in
                    self?.ingredientsRow = result
                }
                .store(in: &subscriptions)

        }
    }
}
