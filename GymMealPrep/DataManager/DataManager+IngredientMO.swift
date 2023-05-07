//
//  DataManager+IngredientMO.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/7/23.
//

import Foundation

extension DataManager {
    
    /// Update an ingredient managed object with data from ingredient, or if the ingredientMO with correct id is not found create a new ingredientMO
    /// - Parameter ingredient: object to update with
    func updateAndSave(ingredient: Ingredient) {
        let predicate = NSPredicate(format: "id = %@", ingredient.id as CVarArg)
        let result = fetchFirst(IngredientMO.self, predicate: predicate)
        switch result {
        case .success(let success):
            if let ingredientMO = success {
                update(ingredientMO: ingredientMO, from: ingredient)
            } else {
                ingredientMO(from: ingredient)
            }
        case .failure(let failure):
            print("Could not fetch ingredientMO to update: \(failure.localizedDescription)")
        }
        saveContext()
    }
    
    
    
    ///Delete a ingredientMO object with id matching input food id
    func delete(ingredient: Ingredient){
        let predicate = NSPredicate(format: "id = %@", ingredient.id as CVarArg)
        let result = fetchFirst(IngredientMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let ingredinetMO = managedObject {
                managedContext.delete(ingredinetMO)
            }
        case .failure(let failure):
            print("Could not fetch ingredientMO to delete: \(failure.localizedDescription)")
        }
        saveContext()
    }
    
    private func update(ingredientMO target: IngredientMO, from source: Ingredient) {
        // ID is created only once so it is not overriden here
        target.quantity = source.quantity
        target.unitOfMeasure = source.unitOfMeasure
        addToIngredients(food: source.food, to: target)
        target.calories = source.nutritionData.calories
        target.carbs = source.nutritionData.carb
        target.fat = source.nutritionData.fat
        target.protein = source.nutritionData.protein
    }
    private func ingredientMO(from source: Ingredient) {
        //Since ingredient is identifiable use the id present in Ingredient

        let ingredientMO = IngredientMO(context: managedContext, id: source.id, calories: source.nutritionData.calories, carbs: source.nutritionData.carb, fat: source.nutritionData.fat, protein: source.nutritionData.protein, quantity: source.quantity, unitOfMeasure: source.unitOfMeasure)
        addToIngredients(food: source.food, to: ingredientMO)
    }
}
