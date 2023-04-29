//
//  FoodMO+CoreDataProperties.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//
//

import Foundation
import CoreData


extension FoodMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodMO> {
        return NSFetchRequest<FoodMO>(entityName: "FoodMO")
    }

    @NSManaged public var name: String?
    @NSManaged public var ingredients: NSSet?

}

// MARK: Generated accessors for ingredients
extension FoodMO {

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: IngredientMO)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: IngredientMO)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSSet)

}

extension FoodMO : Identifiable {

}
