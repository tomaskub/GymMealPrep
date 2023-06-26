//
//  DataManager+MealPlanMO.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/26/23.
//

import Foundation

protocol MealPlanDataManagerProtocol {
    func updateAndSave(mealPlan: MealPlan)
    
    func delete(mealPlan: MealPlan)
}

extension DataManager: MealPlanDataManagerProtocol {
    
    func updateAndSave(mealPlan: MealPlan) {
        let result = fetchFirst(MealPlanMO.self, predicate: NSPredicate(format: "id = @%", mealPlan.id))
        switch result {
        case .success(let success):
            if let mealPlanMO = success {
                update(mealPlanMO: mealPlanMO, from: mealPlan)
            } else {
                _ = mealPlanMO(from: mealPlan)
            }
        case .failure(let failure):
            print("Could not fetch mealPlanMO to update: \(failure.localizedDescription)")
        }
        saveContext()
    }
    
    func delete(mealPlan: MealPlan) {
        let result = fetchFirst(MealPlanMO.self, predicate: NSPredicate(format: "id = @%", mealPlan.id))
        switch result {
        case .success(let success):
            if let mealPlanMO = success {
                managedContext.delete(mealPlanMO)
            }
        case .failure(let failure):
            print("Could not fetch mealPlanMO to delete: \(failure.localizedDescription)")
        }
        saveContext()
    }
    
    private func update(mealPlanMO target: MealPlanMO, from source: MealPlan) {
            // assing values from source to target
    }
    
    private func mealPlanMO(from source: MealPlan) -> MealPlanMO {
        let mealPlanMO = MealPlanMO(context: managedContext, id: source.id)
        
        if let name = source.name {
            mealPlanMO.name = name
        }
        for meal in source.meals {
            addToMealPlan(meal: meal, to: mealPlanMO)
        }
    }
}
