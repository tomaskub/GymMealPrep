//
//  Tag.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//

import Foundation

struct Tag: Identifiable {
    var id: UUID
    var text: String
    var color: (Double, Double, Double)?
    
    init(id: UUID, text: String, color: (Double, Double, Double)? = nil) {
        self.id = id
        self.text = text
        self.color = color
    }
    
    init(tagMO: TagMO) {
        self.id = tagMO.id
        self.text = tagMO.text
    }
}
