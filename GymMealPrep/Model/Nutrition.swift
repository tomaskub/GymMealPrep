//
//  Nutrition.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//

import Foundation

struct Nutrition {
    var calories: Float
    var carb: Float
    var fat: Float
    var protein: Float
    
    
    init(calories: Float, carb: Float, fat: Float, protein: Float) {
        self.calories = calories
        self.carb = carb
        self.fat = fat
        self.protein = protein
    }
    init() {
        self.calories = 0
        self.carb = 0
        self.fat = 0
        self.protein = 0
    }
}
