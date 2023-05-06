//
//  FoodMO+CoreDataClass.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//
//

import Foundation
import CoreData

@objc(FoodMO)
public class FoodMO: NSManagedObject {
    
    public init(context: NSManagedObjectContext, id: UUID = UUID(), name: String) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "FoodMO", in: context)!
        super.init(entity: entityDescription, insertInto: context)
        self.id = id
        self.name = name
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
