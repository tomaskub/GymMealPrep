//
//  Recipie.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//

import Foundation


struct Recipie: Identifiable {
    var id: UUID
    var name: String
    var servings: Int
    var timeCookingInMinutes: Int?
    var timePreparingInMinutes: Int?
    var timeWaitingInMinutes: Int?
    var imageData: Data?
    
    var ingredients: [Ingredient]
    var instructions: [Instruction]
    var tags: [Tag]
    
    var nutritionData: Nutrition {
        return ingredients.map({ $0.nutritionData }).reduce(Nutrition.zero, + ).divideBy(servings)
        
    }
    
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
    }
    
    init(recipieMO: RecipieMO) {
        self.id = recipieMO.id
        self.name = recipieMO.name
        self.servings = Int(recipieMO.servings)
        self.timeCookingInMinutes = Int(recipieMO.timeCooking)
        self.timePreparingInMinutes = Int(recipieMO.timePreparing)
        self.timeWaitingInMinutes = Int(recipieMO.timeWaiting)
        self.imageData = recipieMO.imageData
        
        if let tagsSet = recipieMO.tags {
            self.tags = Array(_immutableCocoaArray: tagsSet).map({Tag(tagMO: $0)})
        } else {
            self.tags = []
        }
        
        if let ingredientsSet = recipieMO.ingredients {
            self.ingredients = Array(_immutableCocoaArray: ingredientsSet).map({ Ingredient(ingredientMO: $0)})
        } else {
            self.ingredients = []
        }
        
        if let instructionsSet = recipieMO.instructions {
            self.instructions = Array(_immutableCocoaArray: instructionsSet).map( { Instruction(instructionMO: $0) })
        } else {
            self.instructions = []
        }
    }
}
