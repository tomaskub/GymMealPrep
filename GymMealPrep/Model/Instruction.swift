//
//  File.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//

import Foundation

struct Instruction: Identifiable {
    var id: UUID
    var step: Int
    var text: String?
    
    init(id: UUID, step: Int, text: String? = nil) {
        self.id = id
        self.step = step
        self.text = text
    }
    
    init(instructionMO: InstructionMO) {
        self.id = instructionMO.id
        self.step = Int(instructionMO.step)
        self.text = instructionMO.text
    }
}
