//
//  DataManager+RecipeMO.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/8/23.
//

import Foundation

protocol RecipeDataManagerProtocol {
    
    func updateAndSave(recipe: Recipe)
    
    func delete(recipe: Recipe)
    
}

extension DataManager: RecipeDataManagerProtocol {
    
    func updateAndSave(recipe: Recipe) {
        let predicate = NSPredicate(format: "id = %@", recipe.id as CVarArg)
        let result = fetchFirst(RecipeMO.self, predicate: predicate)
        switch result {
        case .success(let success):
            if let recipeMO = success {
                update(recipeMO: recipeMO, from: recipe)
            } else {
                recipeMO(from: recipe)
            }
        case .failure(let failure):
            print("Could not fetch RecipeMO to update: \(failure.localizedDescription)")
        }
        saveContext()
    }
    
    func delete(recipe: Recipe) {
        let predicate = NSPredicate(format: "id = %@", recipe.id as CVarArg)
        let result = fetchFirst(RecipeMO.self, predicate: predicate)
        switch result {
        case .success(let success):
            if let recipeMO = success {
                managedContext.delete(recipeMO)
            }
        case .failure(let failure):
            print("Could not fetch RecipeMO to delete: \(failure.localizedDescription)")
        }
        saveContext()
    }
    
    private func update(recipeMO target: RecipeMO, from source: Recipe) {
        target.imageData = source.imageData
        target.name = source.name
        target.servings = Int64(source.servings)
        if let timeCooking = source.timeCookingInMinutes {
            target.timeCooking = Int64(timeCooking)
        }
        if let timePreparing = source.timePreparingInMinutes {
            target.timePreparing = Int64(timePreparing)
        }
        if let timeWaiting = source.timeWaitingInMinutes {
            target.timeWaiting = Int64(timeWaiting)
        }
        //manage ingredients relations
        if let ingredients = target.ingredients?.compactMap({ $0 as? IngredientMO}) {
            for ingredient in ingredients {
                if !source.ingredients.contains(where: { $0.id == ingredient.id }) {
                    target.removeFromIngredients(ingredient)
                }
            }
            for ingredient in source.ingredients {
                if !ingredients.contains(where: { $0.id == ingredient.id }) {
                    addToRecipe(ingredient: ingredient, to: target)
                }
            }
        } else {
            for ingredient in source.ingredients {
                addToRecipe(ingredient: ingredient, to: target)
            }
        }
        //manage instructions relations
        if let instructions = target.instructions?.compactMap({ $0 as? InstructionMO}) {
            for instruction in instructions {
                if !source.instructions.contains(where: { $0.id == instruction.id }) {
                    target.removeFromInstructions(instruction)
                }
            }
            for instruction in source.instructions {
                if !instructions.contains(where: { $0.id == instruction.id }) {
                    addToRecipe(instruction: instruction, to: target)
                }
            }
        } else {
            for instruction in source.instructions {
                addToRecipe(instruction: instruction, to: target)
            }
        }
        //manage targets relations
        if let tags = target.tags?.compactMap({ $0 as? TagMO }) {
            for tag in tags {
                // check if tag has been deleted
                if !source.tags.contains(where: { $0.id == tag.id }){
                    target.removeFromTags(tag)
                }
            }
            for tag in source.tags {
                if !tags.contains(where: { $0.id == tag.id} ) {
                    addToRecipe(tag: tag, to: target)
                }
            }
        } else {
            for tag in source.tags {
                addToRecipe(tag: tag, to: target)
            }
        }
    }
    
    private func recipeMO(from source: Recipe) {
        
        let recipeMO = RecipeMO(context: managedContext, id: source.id, name: source.name, servings: source.servings, timeCooking: source.timeCookingInMinutes ?? 0, timePreparing: source.timePreparingInMinutes ?? 0, timeWaiting: source.timeWaitingInMinutes ?? 0)
        
        recipeMO.imageData = source.imageData
        
        if !source.ingredients.isEmpty {
            for ingredient in source.ingredients {
                addToRecipe(ingredient: ingredient, to: recipeMO)
            }
        }
        if !source.instructions.isEmpty {
            for instruction in source.instructions {
                addToRecipe(instruction: instruction, to: recipeMO)
            }
        }
        if !source.tags.isEmpty {
            for tag in source.tags {
            addToRecipe(tag: tag, to: recipeMO)
            }
        }
    }
}

