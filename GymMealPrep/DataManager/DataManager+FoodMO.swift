//
//  DataManager+FoodMO.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/7/23.
//

import Foundation

extension DataManager {
    
    /// Update a food managed object with data from food or if the foodMO with correct id is not found create a new foodMO
    /// - Parameter food: object to update with
    func updateAndSave(food: Food) {
        let predicate = NSPredicate(format: "id = %@", food.id as CVarArg)
        let result = fetchFirst(FoodMO.self, predicate: predicate)
        switch result {
        case .success(let success):
            if let foodMO = success {
                update(foodMO: foodMO, from: food)
            } else {
                _ = foodMO(from: food)
            }
        case .failure(let failure):
            print("Could not fetch tag to update: \(failure.localizedDescription)")
        }
        saveContext()
    }
    
    func addToIngredients(food: Food, to ingredient: IngredientMO) {
        let predicate = NSPredicate(format: "id = %@", food.id as CVarArg)
        let result = fetchFirst(FoodMO.self, predicate: predicate)
        switch result {
        case .success(let success):
            if let foodMO = success {
                foodMO.addToIngredients(ingredient)
            } else {
                let foodMO = foodMO(from: food)
                foodMO.addToIngredients(ingredient)
            }
        case .failure(let failure):
            print("Could not fetch tag to update: \(failure.localizedDescription)")
        }
//        saveContext()
    }
     
    ///Delete a FoodMO object with id matching input food id
    func delete(food: Food){
        let predicate = NSPredicate(format: "id = %@", food.id as CVarArg)
        let result = fetchFirst(FoodMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let foodMO = managedObject {
                managedContext.delete(foodMO)
            }
        case .failure(let failure):
            print("Could not fetch tag to delete: \(failure.localizedDescription)")
        }
        saveContext()
    }
    
    private func update(foodMO target: FoodMO, from source: Food) {
        // ID is created only once so it is not overriden here
        target.name = source.name
    }
//    private func foodMO(from source: Food) {
//        //Since tag is identifiable use the id present in Tag
//        let food = FoodMO(context: managedContext, id: source.id, name: source.name)
//    }
    
    private func foodMO(from source: Food) -> FoodMO {
        //Since tag is identifiable use the id present in Tag
        return FoodMO(context: managedContext, id: source.id, name: source.name)
    }
}
