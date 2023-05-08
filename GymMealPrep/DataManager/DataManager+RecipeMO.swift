//
//  DataManager+RecipeMO.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/8/23.
//

import Foundation

extension DataManager {
    
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
        
        if !source.ingredients.isEmpty {
            for ingredient in source.ingredients {
                addToRecipe(ingredient: ingredient, to: target)
            }
        }
        if !source.instructions.isEmpty {
            for instruction in source.instructions {
                addToRecipe(instruction: instruction, to: target)
            }
        }
        if !source.tags.isEmpty {
            for tag in source.tags {
                addToRecipe(tag: tag, to: target)
            }
        }
    }
    private func recipeMO(from source: Recipe) {
        
        let recipeMO = RecipeMO(context: managedContext, id: source.id, name: source.name, servings: source.servings, timeCooking: source.timeCookingInMinutes ?? 0, timePreparing: source.timePreparingInMinutes ?? 0, timeWaiting: source.timeWaitingInMinutes ?? 0)
        
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

