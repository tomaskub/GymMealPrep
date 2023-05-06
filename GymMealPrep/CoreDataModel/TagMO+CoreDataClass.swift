//
//  TagMO+CoreDataClass.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//
//

import Foundation
import CoreData

@objc(TagMO)
public class TagMO: NSManagedObject {

    public init(context: NSManagedObjectContext, id: UUID = UUID(), text: String) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "TagMO", in: context)!
        super.init(entity: entityDescription, insertInto: context)
        self.id = id
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
    public convenience init(context: NSManagedObjectContext){
        fatalError("\(#function) not implemented")
    }
}
