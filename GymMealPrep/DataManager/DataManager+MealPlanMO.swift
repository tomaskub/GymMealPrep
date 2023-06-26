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
        
    }
    
    func delete(mealPlan: MealPlan) {
        
    }
}
