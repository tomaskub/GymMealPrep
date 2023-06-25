//
//  MealMO+CoreDataClass.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//
//

import Foundation
import CoreData

@objc(MealMO)
public class MealMO: NSManagedObject {

    public init(context: NSManagedObjectContext, id: UUID = UUID()) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "MealMO", in: context)!
        super.init(entity: entityDescription, insertInto: context)
        self.id = id
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
