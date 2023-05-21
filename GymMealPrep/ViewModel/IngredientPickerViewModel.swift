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
    
    @Published var ingredientsRow: [([Ingredient], Ingredient)] = []
    
    @Published var ingredientsRaw: [[Ingredient]] = [] {
        didSet {
            var temp = [([Ingredient], Ingredient)]()
            if !ingredientsRaw.isEmpty {
                for row in ingredientsRaw {
                    if let first = row.first {
                        let tempRow: ([Ingredient], Ingredient) = (row, first)
                        temp.append(tempRow)
                    }
                }
            }
            ingredientsRow = temp
        }
    }
    @Published var searchTerm: String = String()
    
    func searchForIngredient() {
        
        if !searchTerm.isEmpty {
            edamamLogicController.getIngredients(for: searchTerm)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    print(completion)
                } receiveValue: { [weak self] result in
                    guard let self else { return }
                    self.ingredientsRaw = result
                }
                .store(in: &subscriptions)

        }
    }
}
