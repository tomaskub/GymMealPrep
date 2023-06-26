//
//  DataManager+InstructionMOTests.swift
//  GymMealPrepTests
//
//  Created by Tomasz Kubiak on 5/7/23.
//

import XCTest
@testable import GymMealPrep

final class DataManagerInstructionMOTests: XCTestCase {
    
    var sut: DataManager!
    override func setUp() {
        sut = DataManager.testing
    }
    
    override func tearDown() {
        sut = nil
    }
    
    /// Test function updateAndSave, with condition that a new Instruction is added
    func testUpdateAndSave_whenNoInstructionExist() throws {
        let instruction = Instruction(step: 1, text: "Test Instruction")
        sut.updateAndSave(instruction: instruction)
        
        let request = InstructionMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", instruction.id as CVarArg)
        request.fetchLimit = 1
        do {
            let result = try sut.managedContext.fetch(request)
            let resutl = try XCTUnwrap(result.first, "There should be instruction retrived")
            XCTAssertTrue(result[0].text == instruction.text, "Text in instructionMO should be equal to text in instruction")
        } catch {
            XCTFail("Error while fetching: \(error.localizedDescription)")
        }
    }
    
    func testUpdateAndSave_whenInstructionExist() {
        let instruction = Instruction(step: 1, text: "Test Instruction")
        sut.updateAndSave(instruction: instruction)
        
        
        let newInstruction = Instruction(id: instruction.id, step: 1, text: "Test Instruction")
        sut.updateAndSave(instruction: newInstruction)
        
        
        let request = InstructionMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", instruction.id as CVarArg)
        request.fetchLimit = 1
        do {
            let result = try sut.managedContext.fetch(request)
            XCTAssertTrue(result[0].text == newInstruction.text, "Text in instructionMO should be equal to text in newInstruction")
        } catch {
            XCTFail("Error while fetching: \(error.localizedDescription)")
        }
    }
    
    func testDeleteInstruction_whenNoInstructionExist() {
        let instruction = Instruction(step: 1, text: "Test Instruction")
        
        sut.delete(instruction: instruction)
        
        let request = InstructionMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", instruction.id as CVarArg)
        request.fetchLimit = 1
        do {
            let result = try sut.managedContext.fetch(request)
            XCTAssertTrue(result.isEmpty, "The resulting array should be empty")
        } catch {
            XCTFail("Error while fetching: \(error.localizedDescription)")
        }
    }
    
    func testAddToRecipe_WhenInstructionExists() {
        let instruction = Instruction(step: 1, text: "Test Instruction")
        sut.updateAndSave(instruction: instruction)
        
        let recipeMO = RecipeMO(context: sut.managedContext, name: "Test Recipe", servings: 4)
        sut.addToRecipe(instruction: instruction, to: recipeMO)
        sut.saveContext()
        
        let request = InstructionMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", instruction.id as CVarArg)
        request.fetchLimit = 1
        do {
            let result = try sut.managedContext.fetch(request)
            let resultInstruction = try XCTUnwrap(result.first, "There should be instructionMO retrieved")
            let recipeResult = try XCTUnwrap(resultInstruction.recipie, "There should be a recipe in retrived instructionMO")
            XCTAssertTrue(recipeResult.id == recipeMO.id, "The recipe retrived should have the id equal to initial recipie id")
        } catch {
            XCTFail("Error while fetching: \(error.localizedDescription)")
        }
    }
    func testAddToRecipe_WhenNoInstructionExists() {
        let instruction = Instruction(step: 1, text: "Test Instruction")
//        sut.updateAndSave(instruction: instruction)
        
        let recipeMO = RecipeMO(context: sut.managedContext, name: "Test Recipe", servings: 4)
        sut.addToRecipe(instruction: instruction, to: recipeMO)
        sut.saveContext()
        
        let request = InstructionMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", instruction.id as CVarArg)
        request.fetchLimit = 1
        do {
            let result = try sut.managedContext.fetch(request)
            let resultInstruction = try XCTUnwrap(result.first, "There should be instructionMO retrieved")
            let recipeResult = try XCTUnwrap(resultInstruction.recipie, "There should be a recipe in retrived instructionMO")
            XCTAssertTrue(recipeResult.id == recipeMO.id, "The recipe retrived should have the id equal to initial recipie id")
        } catch {
            XCTFail("Error while fetching: \(error.localizedDescription)")
        }
    }
    
    func testDeleteInstruction_whenInstructionExists() {
        let instruction = Instruction(step: 1, text: "Test Instruction")
        sut.updateAndSave(instruction: instruction)
        sut.delete(instruction: instruction)
        
        let request = InstructionMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", instruction.id as CVarArg)
        request.fetchLimit = 1
        do {
            let result = try sut.managedContext.fetch(request)
            XCTAssertTrue(result.isEmpty, "The resulting array should be empty")
        } catch {
            XCTFail("Error while fetching: \(error.localizedDescription)")
        }
    }
}
