//
//  MealPlan.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/20/23.
//

import Foundation

struct MealPlan: Identifiable, Hashable {
    var id: UUID
    var name: String?
    var meals: [Meal]
    
    init(id: UUID = UUID(), name: String? = nil, meals: [Meal]) {
        self.id = id
        self.name = name
        self.meals = meals
    }
    
    init(mealPlanMO: MealPlanMO) {
        self.id = mealPlanMO.id
        self.name = mealPlanMO.name
        if let mealsMO = mealPlanMO.meals {
            self.meals = mealsMO.allObjects.compactMap({ $0 as? MealMO }).map({ Meal(mealMO: $0)})
        } else {
            self.meals = []
        }
    }
}
