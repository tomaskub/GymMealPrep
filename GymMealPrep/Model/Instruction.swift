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
    var text: String
}