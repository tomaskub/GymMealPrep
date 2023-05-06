//
//  InstructionMO+CoreDataProperties.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//
//

import Foundation
import CoreData


extension InstructionMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InstructionMO> {
        return NSFetchRequest<InstructionMO>(entityName: "InstructionMO")
    }
    @NSManaged public var id: UUID
    @NSManaged public var step: Int64
    @NSManaged public var text: String?
    @NSManaged public var recipie: RecipeMO?

}

extension InstructionMO : Identifiable {

}
