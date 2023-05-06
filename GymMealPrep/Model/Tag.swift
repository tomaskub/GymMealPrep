//
//  Tag.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//

import Foundation

struct Tag: Identifiable, Hashable {
    
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        lhs.id == rhs.id && lhs.text == rhs.text
    }
    
    var id: UUID
    var text: String
    
    
    init(id: UUID = UUID(), text: String) {
        self.id = id
        self.text = text
    }
    
    init(tagMO: TagMO) {
        self.id = tagMO.id ?? UUID()
        self.text = tagMO.text ?? String()
    }
}
