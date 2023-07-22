//
//  MealPlanMO+CoreDataProperties.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//
//

import Foundation
import CoreData


extension MealPlanMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MealPlanMO> {
        return NSFetchRequest<MealPlanMO>(entityName: "MealPlanMO")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String?
    @NSManaged public var meals: NSOrderedSet?

}

// MARK: Generated accessors for meals
extension MealPlanMO {

    @objc(insertObject:inMealsAtIndex:)
    @NSManaged public func insertIntoMeals(_ value: MealMO, at idx: Int)

    @objc(removeObjectFromMealsAtIndex:)
    @NSManaged public func removeFromMeals(at idx: Int)

    @objc(insertMeals:atIndexes:)
    @NSManaged public func insertIntoMeals(_ values: [MealMO], at indexes: NSIndexSet)

    @objc(removeMealsAtIndexes:)
    @NSManaged public func removeFromMeals(at indexes: NSIndexSet)

    @objc(replaceObjectInMealsAtIndex:withObject:)
    @NSManaged public func replaceMeals(at idx: Int, with value: MealMO)

    @objc(replaceMealsAtIndexes:withMeals:)
    @NSManaged public func replaceMeals(at indexes: NSIndexSet, with values: [MealMO])

    @objc(addMealsObject:)
    @NSManaged public func addToMeals(_ value: MealMO)

    @objc(removeMealsObject:)
    @NSManaged public func removeFromMeals(_ value: MealMO)

    @objc(addMeals:)
    @NSManaged public func addToMeals(_ values: NSOrderedSet)

    @objc(removeMeals:)
    @NSManaged public func removeFromMeals(_ values: NSOrderedSet)

}

extension MealPlanMO : Identifiable {

}
