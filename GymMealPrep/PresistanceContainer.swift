//
//  PresistanceContainer.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//

import Foundation
import CoreData

struct PersistanceContainer {
    
    let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Fatal Error: \(error), \(error.userInfo)")
            }
        })
    }
}
