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
            //here add data to the preview
            try? self.managedContext.save()
            
        }
        //Build FRC
        let fetchRequest = RecipeMO.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        self.recipieFRC = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        //Initial fetch
        if type == .preview {
            addPreviewData()
        }
        try? recipieFRC.performFetch()
        if let newRecipes = recipieFRC.fetchedObjects {
            self.recipeArray = newRecipes.map { Recipe(recipeMO: $0) }
        }
    }
    
    func addPreviewData() {
        let recipe = RecipeMO(context: managedContext, name: "TestRecipe", servings: 4)
        let tag = TagMO(context: managedContext, text: "Test tag")
        let food = FoodMO(context: managedContext, name: "Test Food")
        let ingredient = IngredientMO(context: managedContext, calories: 100, carbs: 8, fat: 10, protein: 10, quantity: 2, unitOfMeasure: "cups")
        
        recipe.addToTags(tag)
        food.addToIngredients(ingredient)
        recipe.addToIngredients(ingredient)
        
        try? managedContext.save()
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

