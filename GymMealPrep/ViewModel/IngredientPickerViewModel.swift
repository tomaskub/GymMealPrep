//
//  IngredientPickerViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/16/23.
//

import Foundation
import Combine

class IngredientPickerViewModelProtocol: ObservableObject {
    @Published var ingredientsRow: [([Ingredient], Ingredient)] = []
    @Published var searchTerm: String = String()
    
    func searchForIngredient() {
        assertionFailure("Function searchForIngredient has to be overriden")
    }
}

class IngredientPickerViewModel: IngredientPickerViewModelProtocol {
    
    var subscriptions = Set<AnyCancellable>()
    let edamamLogicController: EdamamLogicController = EdamamLogicController(networkController: NetworkController())
    
    
    
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
    
    
    
    init(ingredients: [[Ingredient]] = [[]], searchTerm: String = String()){
        super.init()
        self.ingredientsRaw = ingredients
        self.searchTerm = searchTerm
    }
    
    override func searchForIngredient() {
        
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
