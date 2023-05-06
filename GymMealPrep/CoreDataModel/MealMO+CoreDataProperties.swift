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

    @NSManaged public var ingredients: IngredientMO?
    @NSManaged public var plans: MealPlanMO?
    @NSManaged public var recipies: RecipeMO?

}

extension MealMO : Identifiable {

}
