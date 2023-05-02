//
//  Ingredient.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//

import Foundation

struct Ingredient {
    
    var food: Food
    var quantity: Double
    var unitOfMeasure: String
    
    var nutritionData: Nutrition
    
    init(food: Food, quantity: Double, unitOfMeasure: String, nutritionData: Nutrition) {
        self.food = food
        self.quantity = quantity
        self.unitOfMeasure = unitOfMeasure
        self.nutritionData = nutritionData
    }
    
    init(ingredientMO: IngredientMO) {
        guard let foodMO = ingredientMO.food else { fatalError() }
        self.food = Food(foodMO: foodMO)
        self.quantity = ingredientMO.quantity
        self.unitOfMeasure = ingredientMO.unitOfMeasure
        self.nutritionData = Nutrition(calories: ingredientMO.calories, carb: ingredientMO.carbs, fat: ingredientMO.fat, protein: ingredientMO.protein)
    }
}
