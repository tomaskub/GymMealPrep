//
//  DataManager+InstructionMO.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/7/23.
//

import Foundation

extension DataManager {
    
    func updateAndSave(instruction: Instruction) {
        let predicate = NSPredicate(format: "id = %@", instruction.id as CVarArg)
        let result = fetchFirst(InstructionMO.self, predicate: predicate)
        switch result {
        case .success(let success):
            if let instructionMO = success {
                update(instructionMO: instructionMO, from: instruction)
            } else {
               let instructionMO = instructionMO(from: instruction)
            }
        case .failure(let failure):
            print("Could not fetch instructionMO to update: \(failure.localizedDescription)")
        }
        saveContext()
    }
    func delete(instruction: Instruction) {
        let predicate = NSPredicate(format: "id = %@", instruction.id as CVarArg)
        let result = fetchFirst(InstructionMO.self, predicate: predicate)
        switch result {
        case .success(let success):
            if let instructionMO = success {
                managedContext.delete(instructionMO)
            }
        case .failure(let failure):
            print("Could not fetch instructionMO to delete: \(failure.localizedDescription)")
        }
        saveContext()
    }
    
    func addToRecipe(instruction: Instruction, to recipeMO: RecipeMO) {
        let predicate = NSPredicate(format: "id = %@", instruction.id as CVarArg)
        let result = fetchFirst(InstructionMO.self, predicate: predicate)
        switch result {
        case .success(let success):
            if let instructionMO = success {
                recipeMO.addToInstructions(instructionMO)
            } else {
               let instructionMO = instructionMO(from: instruction)
                recipeMO.addToInstructions(instructionMO)
            }
        case .failure(let failure):
            print("Could not fetch instructionMO to update: \(failure.localizedDescription)")
        }
    }
    
    
    private func update(instructionMO target: InstructionMO, from source: Instruction) {
        target.step = Int64(source.step)
        target.text = source.text
    }
    
    private func instructionMO(from source: Instruction) -> InstructionMO {
        return InstructionMO(context: managedContext, id: source.id, step: source.step, text: source.text)
    }
}
