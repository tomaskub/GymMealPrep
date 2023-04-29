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
    
    static let shared = DataManager(type: .normal)
    static let testing = DataManager(type: .testing)
    static let preview = DataManager(type: .preview)
    
    fileprivate var managedContext: NSManagedObjectContext
    
    private init(type: DataManagerType) {
        
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
        super.init()
    }
}
