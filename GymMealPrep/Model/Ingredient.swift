//
//  Ingredient.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//

import Foundation

protocol IngredientProtocol: Identifiable, Hashable {
    
    var id: UUID { get set }
    var food: Food { get set }
    var quantity: Double { get set }
    var unitOfMeasure: String { get set }
    var nutritionData: any NutritionProtocol { get set }
    
}

struct Ingredient: IngredientProtocol {
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.id == rhs.id &&
        lhs.food.id == rhs.food.id &&
        lhs.quantity == rhs.quantity &&
        lhs.unitOfMeasure == rhs.unitOfMeasure
        
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: UUID
    var food: Food
    var quantity: Double
    var unitOfMeasure: String
    
    var nutritionData: any NutritionProtocol
    
    init(id: UUID = UUID(), food: Food, quantity: Double, unitOfMeasure: String, nutritionData: Nutrition) {
        self.id = id
        self.food = food
        self.quantity = quantity
        self.unitOfMeasure = unitOfMeasure
        self.nutritionData = nutritionData
    }
    
    init(ingredientMO: IngredientMO) {
        self.id = ingredientMO.id
        guard let foodMO = ingredientMO.food else { fatalError() }
        self.food = Food(foodMO: foodMO)
        self.quantity = ingredientMO.quantity
        self.unitOfMeasure = ingredientMO.unitOfMeasure
        self.nutritionData = Nutrition(calories: ingredientMO.calories, carb: ingredientMO.carbs, fat: ingredientMO.fat, protein: ingredientMO.protein)
    }
    
    /// Initializer creating an empty ingredient to be overriden 
    init() {
        self.id = UUID()
        self.food = Food(name: String())
        self.quantity = Double()
        self.unitOfMeasure = String()
        self.nutritionData = Nutrition.zero
    }
    
    
}



