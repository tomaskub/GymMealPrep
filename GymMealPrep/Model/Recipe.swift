//
//  Recipie.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//

import Foundation


struct Recipe: Identifiable {
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
    
    init(id: UUID, name: String,servings: Int, timeCookingInMinutes: Int, timePreparingInMinutes: Int, timeWaitingInMinutes: Int, ingredients: [Ingredient], instructions: [Instruction], imageData: Data? = nil, tags: [Tag]) {
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
    
    init(recipeMO: RecipeMO) {
        //non optional properties
        self.id = recipeMO.id
        self.name = recipeMO.name
        self.servings = Int(recipeMO.servings)
        //optional in CD model
        self.timeCookingInMinutes = Int(recipeMO.timeCooking)
        self.timePreparingInMinutes = Int(recipeMO.timePreparing)
        self.timeWaitingInMinutes = Int(recipeMO.timeWaiting)
        //optional in Recipe, RecipeMO and CD model
        self.imageData = recipeMO.imageData
        
        if let tags = recipeMO.tags {
            self.tags = tags.allObjects.compactMap({ $0 as? TagMO}).map({ Tag(tagMO: $0 )})
        } else {
            self.tags = []
        }
        
        if let ingredients = recipeMO.ingredients {
            self.ingredients = ingredients.allObjects.compactMap({ $0 as? IngredientMO}).map({Ingredient(ingredientMO: $0)})
        } else {
            self.ingredients = []
        }
        
        if let instructionsSet = recipeMO.instructions {
            self.instructions = instructionsSet.allObjects.compactMap({ $0 as? InstructionMO }).map( { Instruction(instructionMO: $0) })
        } else {
            self.instructions = []
        }
    }
}