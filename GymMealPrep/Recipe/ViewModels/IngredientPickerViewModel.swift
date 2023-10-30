//
//  IngredientPickerViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/16/23.
//

import Foundation
import Combine

/// Protocol describing requirements for IngredientPickerView view model. All of the properties have to be declared as published, unless otherwise stated.
///
/// *Required properties*
///  - ingredientsRow - an array of tuples containing an array of ingredients and a ingredient to display. All of the ingredients have to be the same food, as the view will only update
///  - searchTerm - used by the search field of the view
///
/// Required functions:
///  - searchForIngrediens - triggered on search field submit or press of search button
protocol IngredientPickerViewModelProtocol: ObservableObject {
    
    var ingredientsRow: [([Ingredient], Ingredient)] { get set }
    var searchTerm: String { get set }
    
    func searchForIngredient() -> Void
}

class IngredientPickerViewModel: IngredientPickerViewModelProtocol {
    
    //Ingredient picker view model protocol properties
    @Published var ingredientsRow: [([Ingredient], Ingredient)] = []
    @Published var searchTerm: String = String()
    
    let originalSearchTerm: String?
    
    var subscriptions = Set<AnyCancellable>()
    let edamamLogicController: EdamamLogicController
    
    init(networkController: NetworkController, ingredients: [[Ingredient]] = [[]], searchTerm: String = String()){
        self.edamamLogicController = EdamamLogicController(networkController: networkController)
        self.searchTerm = searchTerm
        if !searchTerm.isEmpty {
            self.originalSearchTerm = searchTerm
        } else {
            self.originalSearchTerm = nil
        }
        self.ingredientsRow = tranformToRow(data: ingredients)
    }
    
    func searchForIngredient() {
        
        if !searchTerm.isEmpty {
            edamamLogicController.getIngredients(for: searchTerm)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    print(completion)
                } receiveValue: { [weak self] result in
                    guard let self else { return }
                    self.ingredientsRow = self.tranformToRow(data: result)
                }
                .store(in: &subscriptions)

        }
    }
    
    private func tranformToRow(data: [[Ingredient]]) -> [([Ingredient], Ingredient)] {
            var temp = [([Ingredient], Ingredient)]()
                for row in data {
                    if let first = row.first {
                        let tempRow: ([Ingredient], Ingredient) = (row, first)
                        temp.append(tempRow)
                    }
                }
            return temp
        }
}
