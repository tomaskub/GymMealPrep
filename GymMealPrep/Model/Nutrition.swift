//
//  Nutrition.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//

import Foundation

protocol NutritionProtocol: AdditiveArithmetic, Hashable {
    var calories: Float { get set }
    var carb: Float { get set }
    var fat: Float { get set }
    var protein: Float { get set }
    func multiplyBy(_ factor: Double) -> Nutrition
}

struct Nutrition: NutritionProtocol {
    
    static func - (lhs: Nutrition, rhs: Nutrition) -> Nutrition {
        let protein = lhs.protein - rhs.protein
        let fat = lhs.fat - rhs.fat
        let carbs = lhs.carb - rhs.carb
        let cal = lhs.calories - rhs.calories
        
        return Nutrition(calories: cal, carb: carbs, fat: fat,protein: protein)
    }
    
    static func + (lhs: Nutrition, rhs: Nutrition) -> Nutrition {
        let protein = lhs.protein + rhs.protein
        let fat = lhs.fat + rhs.fat
        let carbs = lhs.carb + rhs.carb
        let cal = lhs.calories + rhs.calories
        return Nutrition(calories: cal, carb: carbs, fat: fat, protein: protein)
    }
    
    /// Divide the nutrition object properties by given parameter
    /// - Parameter divider: used to divide the protein, fat, carb, and calories
    /// - Returns: Nutrition object with properties divided by parameter
    func divideBy(_ divider: Int) -> Nutrition {
        let protein = self.protein / Float(divider)
        let fat = self.fat / Float(divider)
        let carb = self.carb / Float(divider)
        let calories = self.calories / Float(divider)
        return Nutrition(calories: calories, carb: carb, fat: fat, protein: protein)
    }
    
    /// Multiply the nutrition object properties by given parameter
    /// - Parameter factor: used to multiply the protein, fat, carb and calories
    /// - Returns: Nutrition object with properties multiplied by the parameter
    func multiplyBy(_ factor: Double) -> Nutrition {
        let protein = self.protein * Float(factor)
        let fat = self.fat * Float(factor)
        let carb = self.carb * Float(factor)
        let calories = self.calories * Float(factor)
        return Nutrition(calories: calories, carb: carb, fat: fat, protein: protein)
    }
    
    static var zero: Nutrition = .init()
    
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
