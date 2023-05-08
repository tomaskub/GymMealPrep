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
    private(set) var managedContext: NSManagedObjectContext
    private let recipieFRC: NSFetchedResultsController<RecipeMO>
    
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
        }
        //Build FRC
        let fetchRequest = RecipeMO.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        self.recipieFRC = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        if type == .preview {
            addPreviewData()
        }
        //Initial fetch
        try? recipieFRC.performFetch()
        if let newRecipes = recipieFRC.fetchedObjects {
            self.recipeArray = newRecipes.map { Recipe(recipeMO: $0) }
        }
    }
    
    //MARK: HELPER METHODS
    ///Add data for previews shown in swiftui views
    func addPreviewData() {
        let recipe = RecipeMO(context: managedContext, name: "TestRecipe", servings: 4)
        let tag = TagMO(context: managedContext, text: "Test tag")
        let food = FoodMO(context: managedContext, name: "Test Food")
        let ingredient = IngredientMO(context: managedContext, calories: 100, carbs: 8, fat: 10, protein: 10, quantity: 2, unitOfMeasure: "cups")
        
        recipe.addToTags(tag)
        food.addToIngredients(ingredient)
        recipe.addToIngredients(ingredient)
        
        saveContext()
    }
    ///Checks for changes in the managed object context and saves if uncommited changes are present
    func saveContext() {
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch let error {
                print("Error saving: \(error) - \(error.localizedDescription)")
            }
        }
    }
    
    /// Fetch first object matching the predicate, if fetch fails return error
    /// ```
    /// // Example of use with update or create:
    ///let result = fetchFirst(ManagedObjectClass.self, predicate)
    /// switch result {
    ///    case .success(let resultingObject):
    ///         if let managedObjectClass = resultingObject {
    ///            // update the object
    ///         } else {
    ///            // create a new object
    ///         }
    ///    case .failure(let error) {
    ///            // handle error
    ///         }
    ///    }
    /// ```
    /// - Parameters:
    ///   - objectType: type of object to be fetched
    ///   - predicate: predicate to be assigned to the fetch function
    /// - Returns: Fetched object or an error
    func fetchFirst<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate?) -> Result<T?, Error> {
        let request = objectType.fetchRequest()
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            let result = try managedContext.fetch(request) as? [T]
            return .success(result?.first)
        } catch {
            return .failure(error)
        }
    }
}

//MARK: FRC DELEGATE METHODS
extension DataManager: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            guard let fetchedObjects = controller.fetchedObjects else { return }
            let newRecipes = fetchedObjects.compactMap({$0 as? RecipeMO})
            self.recipeArray = newRecipes.map({ Recipe(recipeMO: $0) })
    }
}
