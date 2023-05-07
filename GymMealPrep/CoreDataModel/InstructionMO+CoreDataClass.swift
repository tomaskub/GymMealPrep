//
//  InstructionMO+CoreDataClass.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//
//

import Foundation
import CoreData

@objc(InstructionMO)
public class InstructionMO: NSManagedObject {
    
    public init(context: NSManagedObjectContext, id: UUID = UUID(), step: Int, text: String) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "InstructionMO", in: context)!
        super.init(entity: entityDescription, insertInto: context)
        self.id = id
        self.step = Int64(step)
        self.text = text
    }
    
    
    @objc override private init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    @available(*, unavailable)
    public init() {
        fatalError("\(#function) not implemented")
    }
    
    @available(*, unavailable)
    public convenience init(context: NSManagedObjectContext) {
        fatalError("\(#function) not implemented")
    }
}
