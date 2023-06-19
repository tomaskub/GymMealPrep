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
        if let ingredientsMO = mealMO.ingredients {
            self.ingredients = ingredientsMO
                .allObjects
                .compactMap({ $0 as? IngredientMO})
                .map({ Ingredient(ingredientMO: $0) })
        }
        
        if let recipesMO = mealMO.recipes {
            self.recipes = recipesMO
                .allObjects
                .compactMap({ $0 as? RecipeMO })
                .map({ Recipe(recipeMO: $0) })
        }
        
    }
    
    
}
