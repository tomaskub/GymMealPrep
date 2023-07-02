//
//  MealPlanViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/29/23.
//

import Foundation

protocol MealPlanViewModelProtocol: ObservableObject {
    var mealPlan: MealPlan { get }
    var mealPlanName: String { get set }
    
    func removeFromMeal(meal: Meal, _: Ingredient)
    
    func removeFromMeal(meal: Meal, _: Recipe)
    
}

class MealPlanViewModel: MealPlanViewModelProtocol {
    
    @Published var mealPlanName: String
    @Published var mealPlan: MealPlan
    private var dataManager: MealPlanDataManagerProtocol
    
    init(mealPlan: MealPlan, dataManager: MealPlanDataManagerProtocol = DataManager.shared as MealPlanDataManagerProtocol) {
        self.mealPlan = mealPlan
        self.dataManager = dataManager
        if let name = mealPlan.name {
            self.mealPlanName = name
        } else {
            self.mealPlanName = String()
        }
    }
    
    func removeFromMeal(meal: Meal, _: Ingredient) {
        //TODO: IMPLEMENT REMOVING INGREDIENT FROM MEAL
    }
    
    func removeFromMeal(meal: Meal, _: Recipe) {
        //TODO: IMPLEMENT REMOVING RECIPE FROM MEAL
    }
}
