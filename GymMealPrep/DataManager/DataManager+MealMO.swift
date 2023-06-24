//
//  DataManager+MealMO.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/24/23.
//

import Foundation

protocol MealDataManagerProtocol {
    
    func updateAndSave(meal: Meal)
    
    func delete(meal: Meal)
}

extension DataManager: MealDataManagerProtocol {
    
    func updateAndSave(meal: Meal) {
        let predicate = NSPredicate(format: "id = %@", meal.id as CVarArg)
        let result = fetchFirst(MealMO.self, predicate: predicate)
        switch result {
        case .success(let success):
            if let mealMO = success {
                update(mealMO: mealMO, from: meal)
            } else {
                mealMO(from: meal)
            }
        case .failure(let failure):
            print("Could not fetch mealMO to update: \(failure.localizedDescription)")
        }
        saveContext()
    }
    
    func delete(meal: Meal) {
        let predicate = NSPredicate(format: "id = %@", meal.id as CVarArg)
        let result = fetchFirst(MealMO.self, predicate: predicate)
        switch result {
        case .success(let success):
            if let mealMO = success {
                managedContext.delete(mealMO)
            }
        case .failure(let failure):
            print("Could not fetch mealMO to delete: \(failure.localizedDescription)")
        }
        saveContext()
    }
    
    private func mealMO(from meal: Meal) {
        //TODO: IMPLEMENT MEAL MO CREATION
    }
    
    private func update(mealMO target: MealMO, from source: Meal) {
        // TODO: IMPLEMENT UPDATE MEAL FUNCTION
    }
}
