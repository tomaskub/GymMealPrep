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

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var meals: MealMO?

}

extension MealPlanMO : Identifiable {

}
