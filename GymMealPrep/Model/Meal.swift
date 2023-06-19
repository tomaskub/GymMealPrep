//
//  Meal.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/19/23.
//

import Foundation

struct Meal: Identifiable, Hashable {
    var id: UUID
    var ingredients: [Ingredient]
    var recipes: [Recipe]
    
    init(id: UUID = UUID(), ingredients: [Ingredient] = [], recipies: [Recipe] = []) {
        self.id = id
        self.ingredients = ingredients
        self.recipes = recipies
    }
    
    init(mealMO: MealMO) {
        self.id = mealMO.id
        self.ingredients = [Ingredient(ingredientMO: mealMO.ingredients)]
        self.recipes = Recipe(recipeMO: mealMO.recipies)
    }
    
    
}
