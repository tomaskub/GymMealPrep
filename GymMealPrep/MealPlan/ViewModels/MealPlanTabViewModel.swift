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
    
}

class MealPlanTabViewModel: MealPlanTabViewModelProtocol {
    
    @Published private var dataManager: DataManager
    private var subscriptions = Set<AnyCancellable>()
    var mealPlanArray: [MealPlan] {
        dataManager.mealPlanArray
    }
    
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
        
        dataManager.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
        .store(in: &subscriptions)
    }
    
    func deleteMealPlan(_ mealPlan: MealPlan) {
        //TODO: IMPLEMENT DELETE FUNCTION
    }
}


