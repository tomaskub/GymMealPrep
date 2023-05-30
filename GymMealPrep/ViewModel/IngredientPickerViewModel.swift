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
    
    var subscriptions = Set<AnyCancellable>()
    let edamamLogicController: EdamamLogicController = EdamamLogicController(networkController: NetworkController())
    
    //TODO: MOVE THIS INTO COMBINE 
    var ingredientsRaw: [[Ingredient]] = [] {
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
        self.ingredientsRaw = ingredients
        self.searchTerm = searchTerm
    }
    
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
