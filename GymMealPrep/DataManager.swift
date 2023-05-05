//
//  DataManager.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//

import Foundation
import CoreData

enum DataManagerType {
    case normal, preview, testing
}

class DataManager: NSObject, ObservableObject {
    //MARK: PUBLISHED PROPERTIES
    @Published var recipeArray = [Recipe]()
    
    //MARK: STATIC INSTANCES
    static let shared = DataManager(type: .normal)
    static let testing = DataManager(type: .testing)
    static let preview = DataManager(type: .preview)
    
    //MARK: PRIVATE PROPERTIES
    fileprivate var managedContext: NSManagedObjectContext
    private let recipieFRC: NSFetchedResultsController<RecipieMO>
    
    //MARK: INIT
    private init(type: DataManagerType) {
        //Set container depending on type
        switch type {
        case .normal:
            let persistanceContainer = PersistanceContainer()
            self.managedContext = persistanceContainer.viewContext
        case .testing:
            let persistanceContainer = PersistanceContainer(inMemory: true)
            self.managedContext = persistanceContainer.viewContext
        case .preview:
            let persistanceContainer = PersistanceContainer(inMemory: true)
            self.managedContext = persistanceContainer.viewContext
            //here add data to the preview
            try? self.managedContext.save()
            
        }
        //Build FRC
        let fetchRequest = RecipieMO.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        self.recipieFRC = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        //Initial fetch
        try? recipieFRC.performFetch()
        if let newRecipes = recipieFRC.fetchedObjects {
            self.recipeArray = newRecipes.map { Recipe(recipieMO: $0) }
        }
    }
}

//MARK: FRC DELEGATE METHODS
extension DataManager: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            guard let fetchedObjects = controller.fetchedObjects else { return }
            let newRecipes = fetchedObjects.compactMap({$0 as? RecipieMO})
            self.recipeArray = newRecipes.map({ Recipe(recipieMO: $0) })
        
    }
}

