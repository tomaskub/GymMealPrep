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

    @NSManaged public var id: UUID
    @NSManaged public var text: String
    @NSManaged public var recipies: NSSet?

}

// MARK: Generated accessors for recipies
extension TagMO {

    @objc(addRecipiesObject:)
    @NSManaged public func addToRecipies(_ value: RecipieMO)

    @objc(removeRecipiesObject:)
    @NSManaged public func removeFromRecipies(_ value: RecipieMO)

    @objc(addRecipies:)
    @NSManaged public func addToRecipies(_ values: NSSet)

    @objc(removeRecipies:)
    @NSManaged public func removeFromRecipies(_ values: NSSet)

}

extension TagMO : Identifiable {

}
