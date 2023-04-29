//
//  IngredientMO+CoreDataProperties.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//
//

import Foundation
import CoreData


extension IngredientMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IngredientMO> {
        return NSFetchRequest<IngredientMO>(entityName: "IngredientMO")
    }

    @NSManaged public var calories: Float
    @NSManaged public var carbs: Float
    @NSManaged public var fat: Float
    @NSManaged public var protein: Float
    @NSManaged public var quantity: Double
    @NSManaged public var unitOfMeasure: String?
    @NSManaged public var food: FoodMO?
    @NSManaged public var meal: MealMO?
    @NSManaged public var recipie: RecipieMO?

}

extension IngredientMO : Identifiable {

}
