//
//  MealPlanViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/29/23.
//

import Foundation

protocol MealPlanViewModelProtocol: ObservableObject {
    var mealPlan: MealPlan { get }
}

class MealPlanViewModel: MealPlanViewModelProtocol {
    
    @Published var mealPlan: MealPlan
    private var dataManager: MealPlanDataManagerProtocol
    
    init(mealPlan: MealPlan, dataManager: MealPlanDataManagerProtocol = DataManager.shared as MealPlanDataManagerProtocol) {
        self.mealPlan = mealPlan
        self.dataManager = dataManager
    }
}
