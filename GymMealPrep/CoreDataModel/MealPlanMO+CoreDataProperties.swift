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
    @NSManaged public var meals: NSSet?

}

// MARK: Generated accessors for meals
extension MealPlanMO {

    @objc(addMealsObject:)
    @NSManaged public func addToMeals(_ value: MealMO)

    @objc(removeMealsObject:)
    @NSManaged public func removeFromMeals(_ value: MealMO)

    @objc(addMeals:)
    @NSManaged public func addToMeals(_ values: NSSet)

    @objc(removeMeals:)
    @NSManaged public func removeFromMeals(_ values: NSSet)

}

extension MealPlanMO : Identifiable {

}
