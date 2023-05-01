//
//  RecipieMO+CoreDataProperties.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//
//

import Foundation
import CoreData


extension RecipieMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipieMO> {
        return NSFetchRequest<RecipieMO>(entityName: "RecipieMO")
    }
    @NSManaged public var imageData: Data
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var servings: Int64
    @NSManaged public var timeCooking: Int64
    @NSManaged public var timePreparing: Int64
    @NSManaged public var timeWaiting: Int64
    @NSManaged public var ingredients: NSSet?
    @NSManaged public var instructions: NSSet?
    @NSManaged public var meals: MealMO?
    @NSManaged public var tags: NSSet?

}

// MARK: Generated accessors for ingredients
extension RecipieMO {

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: IngredientMO)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: IngredientMO)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSSet)

}

// MARK: Generated accessors for instructions
extension RecipieMO {

    @objc(addInstructionsObject:)
    @NSManaged public func addToInstructions(_ value: InstructionMO)

    @objc(removeInstructionsObject:)
    @NSManaged public func removeFromInstructions(_ value: InstructionMO)

    @objc(addInstructions:)
    @NSManaged public func addToInstructions(_ values: NSSet)

    @objc(removeInstructions:)
    @NSManaged public func removeFromInstructions(_ values: NSSet)

}

// MARK: Generated accessors for tags
extension RecipieMO {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: TagMO)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: TagMO)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}

extension RecipieMO : Identifiable {

}
