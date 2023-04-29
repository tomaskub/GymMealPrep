//
//  Recipie.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//

import Foundation

struct Recipie {
    var id: UUID
    var servings: Int
    var timeCookingInMinutes: Int
    var timePreparingInMinutes: Int
    var timeWaitingInMinutes: Int
    
    var ingredients: [Ingredient]
    
    var instructions: String
    
    var imageData: Data?
    
    var tags: [Tag]
    
    var nutritionData: Nutrition
}
