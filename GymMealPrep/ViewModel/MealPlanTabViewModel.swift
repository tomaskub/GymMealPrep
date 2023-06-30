//
//  MealPlanTabViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/29/23.
//

import Foundation
import Combine

protocol MealPlanTabViewModelProtocol: ObservableObject {
    
    var mealPlanArray: [MealPlan] { get }
    
    func deleteMealPlan(_: MealPlan)
    
    func createMealPlanViewModel(for: MealPlan) -> any MealPlanViewModelProtocol
    
}

class MealPlanTabViewModel: MealPlanTabViewModelProtocol {
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published private var dataManager: DataManager
    
    var mealPlanArray: [MealPlan] {
        dataManager.mealPlanArray
    }
    
    init(dataManager: DataManager = .shared) {
        self.dataManager = dataManager
        
        dataManager.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
        .store(in: &subscriptions)
    }
    
    func deleteMealPlan(_ mealPlan: MealPlan) {
        //TODO: IMPLEMENT DELETE FUNCTION
    }
    
    func createMealPlanViewModel(for mealPlan: MealPlan) -> any MealPlanViewModelProtocol {
        return MealPlanViewModel(mealPlan: mealPlan, dataManager: dataManager as MealPlanDataManagerProtocol)
    }
}


