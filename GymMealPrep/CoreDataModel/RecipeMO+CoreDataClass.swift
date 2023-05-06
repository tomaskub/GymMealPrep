//
//  RecipieMO+CoreDataClass.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//
//

import Foundation
import CoreData

@objc(RecipeMO)
public class RecipeMO: NSManagedObject {
    
    public init(context: NSManagedObjectContext, id: UUID = UUID(),
                name: String,
                servings: Int,
                timeCooking: Int = 0,
                timePreparing: Int = 0,
                timeWaiting: Int = 0) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "RecipeMO", in: context)!
        super.init(entity: entityDescription, insertInto: context)
        self.id = id
        self.name = name
        self.servings = Int64(servings)
        self.timeCooking = Int64(timeCooking)
        self.timePreparing = Int64(timePreparing)
        self.timeWaiting = Int64(timeWaiting)
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
