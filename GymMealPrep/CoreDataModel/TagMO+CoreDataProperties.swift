//
//  TagMO+CoreDataProperties.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//
//

import Foundation
import CoreData


extension TagMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TagMO> {
        return NSFetchRequest<TagMO>(entityName: "TagMO")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var text: String?
    @NSManaged public var recipe: RecipeMO?

}

extension TagMO : Identifiable {

}
