//
//  MealPlanTabViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/29/23.
//

import Foundation

protocol MealPlanTabViewModelProtocol: ObservableObject {
    
    var mealPlanArray: [MealPlan] { get }
    
    func deleteMealPlan(atOffsets: IndexSet)
    
    func createMealPlanViewModel(for: MealPlan) -> any ObservableObject
}
