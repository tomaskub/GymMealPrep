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
                  ingredients: [],
                  instructions: [],
                  tags: [Tag(id: UUID(), text: "Chicken"),
                         Tag(id: UUID(), text: "Rice"),
                         Tag(id: UUID(), text: "Cilantro"),
                         Tag(id: UUID(), text: "Lunch"),
                         Tag(id: UUID(), text: "Lime")],
                  nutritionData: Nutrition(calories: 800, carb: 30, fat: 18, protein: 38))
    }
}
