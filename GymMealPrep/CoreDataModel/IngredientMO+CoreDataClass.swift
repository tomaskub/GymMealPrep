//
//  IngredientMO+CoreDataClass.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//
//

import Foundation
import CoreData

@objc(IngredientMO)
public class IngredientMO: NSManagedObject {

    public init(context: NSManagedObjectContext, id: UUID = UUID(), calories: Float, carbs: Float, fat: Float, protein: Float, quantity: Double, unitOfMeasure: String) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "IngredientMO", in: context)!
        super.init(entity: entityDescription, insertInto: context)
        self.id = id
        self.calories = calories
        self.carbs = carbs
        self.fat = fat
        self.protein = protein
        self.quantity = quantity
        self.unitOfMeasure = unitOfMeasure
        
    }
    @objc override private init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    @available(*, unavailable)
    public init() {
        fatalError("\(#function) not implemented")
    }
    
    @available(*, unavailable)
    public convenience init(context: NSManagedObjectContext) {
        fatalError("\(#function) not implemented")
    }
}
