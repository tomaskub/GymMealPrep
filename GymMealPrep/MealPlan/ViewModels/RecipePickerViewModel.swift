//
//  RecipePickerViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 7/27/23.
//

import Foundation

class RecipePickerViewModel: ObservableObject {
    @Published var searchTerm: String
    @Published var retrievedRecipes: [Recipe]
    
    private var dataManager: DataManager
    
    init(searchTerm: String = String(), retrievedRecipes: [Recipe] = [Recipe](), dataManager: DataManager) {
        self.searchTerm = searchTerm
        self.retrievedRecipes = retrievedRecipes
        self.dataManager = dataManager
    }
    
    func searchRecipes() {
        if searchTerm.isEmpty {
            retrievedRecipes = dataManager.recipeArray
        } else {
            retrievedRecipes = dataManager.recipeArray.filter({ $0.name.lowercased().contains(searchTerm.lowercased())
            })
        }
    }
}
