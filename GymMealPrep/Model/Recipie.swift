//
//  Recipie.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//

import Foundation

struct Recipie {
    var id: UUID
    var name: String
    var servings: Int
    var timeCookingInMinutes: Int
    var timePreparingInMinutes: Int
    var timeWaitingInMinutes: Int
    
    var ingredients: [Ingredient]
    
    var instructions: [Instruction]
    
    var imageData: Data?
    
    var tags: [Tag]
    
    var nutritionData: Nutrition
    
    init(id: UUID, name: String,servings: Int, timeCookingInMinutes: Int, timePreparingInMinutes: Int, timeWaitingInMinutes: Int, ingredients: [Ingredient], instructions: [Instruction], imageData: Data? = nil, tags: [Tag], nutritionData: Nutrition) {
        self.id = id
        self.name = name
        self.servings = servings
        self.timeCookingInMinutes = timeCookingInMinutes
        self.timePreparingInMinutes = timePreparingInMinutes
        self.timeWaitingInMinutes = timeWaitingInMinutes
        self.ingredients = ingredients
        self.instructions = instructions
        self.imageData = imageData
        self.tags = tags
        self.nutritionData = nutritionData
    }
    
    init() {
        self.init(id: UUID(),
                  name: "Cilantro Lime Chicken",
                  servings: 4,
                  timeCookingInMinutes: 30,
                  timePreparingInMinutes: 15,
                  timeWaitingInMinutes: 5,
                  ingredients: [
                  Ingredient(food: Food(name: "Chicken breast"), quantity: 2, unitOfMeasure: "each", nutritionData: Nutrition()),
                  Ingredient(food: Food(name: "Olive oil"), quantity: 1, unitOfMeasure: "tablespoon", nutritionData: Nutrition()),
                  Ingredient(food: Food(name: "Basmati rice"), quantity: 2, unitOfMeasure: "cups", nutritionData: Nutrition())],
                  instructions: [
                  Instruction(id: UUID(), step: 1, text: "Place the chicken in a ziploc bag together with the olive oil, garlic, cumin, salt, pepper, and juice of 1 lime. Allow it to marinate for 15-20 min over the counter."),
                  
                  Instruction(id: UUID(), step: 2, text: "Preheat a skillet over medium-high heat. Cook the chicken for 3-5 minutes per side, or until cooked through."),
                  Instruction(id: UUID(), step: 3, text: "Set aside and allow it to sit for 10 minutes, then slice.")],
                  tags: [Tag(id: UUID(), text: "Chicken"),
                         Tag(id: UUID(), text: "Rice"),
                         Tag(id: UUID(), text: "Cilantro"),
                         Tag(id: UUID(), text: "Lunch"),
                         Tag(id: UUID(), text: "Lime")],
                  nutritionData: Nutrition(calories: 800, carb: 30, fat: 18, protein: 38))
    }
}
