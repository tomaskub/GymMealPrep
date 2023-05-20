//
//  Food.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//

import Foundation

struct Food: Hashable {
    
    var id: UUID
    var name: String
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
    
    init(foodMO: FoodMO) {
        self.id = foodMO.id
        self.name = foodMO.name
    }
}
