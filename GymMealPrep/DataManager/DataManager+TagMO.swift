//
//  DataManager+TagMO.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/7/23.
//

import Foundation
import CoreData

extension DataManager {
    /// Update a tag managed object with data from tag, or if the tagMO with correct id is not found create a new tagMO
    /// - Parameter tag: object to update with
    func updateAndSave(tag: Tag) {
        let predicate = NSPredicate(format: "id = %@", tag.id as CVarArg)
        let result = fetchFirst(TagMO.self, predicate: predicate)
        switch result {
        case .success(let success):
            if let tagMO = success {
                update(tagMO: tagMO, from: tag)
            } else {
                tagMO(from: tag)
            }
        case .failure(let failure):
            print("Could not fetch tag to update: \(failure.localizedDescription)")
        }
        saveContext()
    }
    
    ///Delete a tagMO object with id matching input tag id
    func delete(tag: Tag){
        let predicate = NSPredicate(format: "id = %@", tag.id as CVarArg)
        let result = fetchFirst(TagMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let tagMO = managedObject {
                managedContext.delete(tagMO)
            }
        case .failure(let failure):
            print("Could not fetch tag to delete: \(failure.localizedDescription)")
        }
        saveContext()
    }
    
    func addToRecipe(tag: Tag, to recipe: RecipeMO) {
        let predicate = NSPredicate(format: "id = %@", tag.id as CVarArg)
        let result = fetchFirst(TagMO.self, predicate: predicate)
        switch result {
        case .success(let success):
            if let tagMO = success {
                tagMO.recipe = recipe
            } else {
                let tag = tagMO(from: tag)
                tag.recipe = recipe
            }
        case .failure(let failure):
            print("Could not fetch tag to update: \(failure.localizedDescription)")
        }
    }
    
    private func update(tagMO target: TagMO, from source: Tag) {
        // ID is created only once so it is not overriden here
        target.text = source.text
    }
    
    private func tagMO(from source: Tag) -> TagMO {
        //Since tag is identifiable use the id present in Tag
        return TagMO(context: managedContext,id: source.id, text: source.text)
    }
}

