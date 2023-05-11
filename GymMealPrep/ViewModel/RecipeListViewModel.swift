//
//  RecipieListViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/30/23.
//

import Foundation
import Combine

class RecipeListViewModel: ObservableObject {
    
    @Published private var dataManager: DataManager
    
    private var subscriptions = Set<AnyCancellable>()
    
    var recipeArray: [Recipe] {
        dataManager.recipeArray
    }
    
    
    init(dataManager: DataManager = DataManager.shared) {
        
        self.dataManager = dataManager
        
        //Publish object will change on recive of change in dataManager
        dataManager.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &subscriptions)
    }
    func createRecipeViewModel(recipe: Recipe) -> RecipeViewModel {
        return RecipeViewModel(recipe: recipe, dataManager: dataManager)
    }
}
