//
//  RecipeCreatorViewModelTests.swift
//  GymMealPrepTests
//
//  Created by Tomasz Kubiak on 6/6/23.
//

import XCTest
@testable import GymMealPrep

final class RecipeCreatorViewModelTests: XCTestCase {

    var sut: RecipeCreatorViewModel!
    
    let instructionEntryString =
    "1. Instruction step 1\n2. Instruction step 2\n3. Instruction step 3\n"
    
    override func setUp() {
        sut = RecipeCreatorViewModel()
    }

    override func tearDown() {
        sut = nil
    }

    func testExample() throws {
        print("Entry: \(instructionEntryString)")
        sut.parseInstructions(input: instructionEntryString)
        XCTAssert(sut.parsedInstructions.count == 3, " There should be 3 ingredients parsed")
        
        
    }
}
