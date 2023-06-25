//
//  MealMO+CoreDataProperties.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//
//

import Foundation
import CoreData


extension MealMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MealMO> {
        return NSFetchRequest<MealMO>(entityName: "MealMO")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var ingredients: NSSet?
    @NSManaged public var plan: MealPlanMO?
    @NSManaged public var recipes: NSSet?

}

// MARK: Generated accessors for ingredients
extension MealMO {

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: IngredientMO)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: IngredientMO)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSSet)

}

// MARK: Generated accessors for recipies
extension MealMO {

    @objc(addRecipiesObject:)
    @NSManaged public func addToRecipies(_ value: RecipeMO)

    @objc(removeRecipiesObject:)
    @NSManaged public func removeFromRecipies(_ value: RecipeMO)

    @objc(addRecipies:)
    @NSManaged public func addToRecipies(_ values: NSSet)

    @objc(removeRecipies:)
    @NSManaged public func removeFromRecipies(_ values: NSSet)

}

extension MealMO : Identifiable {

}
