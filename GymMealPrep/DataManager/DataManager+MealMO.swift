//
//  DataManager+MealMO.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/24/23.
//

import Foundation

protocol MealDataManagerProtocol {
    
    func updateAndSave(meal: Meal)
    
    func delete(meal: Meal)
}

extension DataManager: MealDataManagerProtocol {
    
    func updateAndSave(meal: Meal) {
        let predicate = NSPredicate(format: "id = %@", meal.id as CVarArg)
        let result = fetchFirst(MealMO.self, predicate: predicate)
        switch result {
        case .success(let success):
            if let mealMO = success {
                update(mealMO: mealMO, from: meal)
            } else {
                mealMO(from: meal)
            }
        case .failure(let failure):
            print("Could not fetch mealMO to update: \(failure.localizedDescription)")
        }
        saveContext()
    }
    
    func delete(meal: Meal) {
        let predicate = NSPredicate(format: "id = %@", meal.id as CVarArg)
        let result = fetchFirst(MealMO.self, predicate: predicate)
        switch result {
        case .success(let success):
            if let mealMO = success {
                managedContext.delete(mealMO)
            }
        case .failure(let failure):
            print("Could not fetch mealMO to delete: \(failure.localizedDescription)")
        }
        saveContext()
    }
    
    func addToMealPlan(meal: Meal, to mealPlanMO: MealPlanMO) {
        let predicate = NSPredicate(format: "id = %@", meal.id as CVarArg)
        let result = fetchFirst(MealMO.self, predicate: predicate)
        switch result {
        case .success(let success):
            if let mealMO = success {
                mealMO.plan = mealPlanMO
            } else {
                let mealMO = mealMO(from: meal)
                mealMO.plan = mealPlanMO
            }
        case .failure(let failure):
            print("Could not fetch mealMO to update: \(failure.localizedDescription)")
        }
    }
    
    private func mealMO(from source: Meal) -> MealMO {
        let mealMO = MealMO(context: managedContext, id: source.id)
        if !source.ingredients.isEmpty {
            for ingredient in source.ingredients {
                addToMeal(ingredient: ingredient, to: mealMO)
            }
        }
        if !source.recipes.isEmpty {
            for recipe in source.recipes {
                addToMeal(recipe: recipe, to: mealMO)
            }
        }
        return mealMO
    }
    
    private func update(mealMO target: MealMO, from source: Meal) {
        target.id = source.id
        
        // manage ingredients relations
        if let ingredients = target.ingredients?.compactMap({ $0 as? IngredientMO }) {
            for ingredient in ingredients {
                if !source.ingredients.contains(where: { $0.id == ingredient.id }) {
                    target.removeFromIngredients(ingredient)
                }
            }
            for ingredient in source.ingredients {
                if !ingredients.contains(where: { $0.id == ingredient.id }) {
                    addToMeal(ingredient: ingredient, to: target)
                }
            }
        } else {
            for ingredient in source.ingredients {
                addToMeal(ingredient: ingredient, to: target)
            }
        }
        // manage recipes relations
        if let recipies = target.recipes?.compactMap({ $0 as? RecipeMO }) {
            for recipe in recipies {
                if !source.recipes.contains(where: { $0.id == recipe.id }) {
                    target.removeFromRecipies(recipe)
                }
            }
            for recipe in source.recipes {
                if !recipies.contains(where: { $0.id == recipe.id }) {
                    addToMeal(recipe: recipe, to: target)
                }
            }
        } else {
            for recipe in source.recipes {
                    addToMeal(recipe: recipe, to: target)
            }
        }
    }
}
