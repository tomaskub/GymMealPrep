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
    
    let instructionEntryStringWithNumbersAndDots = "1. Instruction step 1\n2. Instruction step 2\n3. Instruction step 3\n"
    
    let instructionEntryStringWithStep =
    """
    Step 1
    Instruction step 1.
    Step 2
    In a small bowl, combine melted butter, garlic, and lemon juice. Pour all over scallops.
    Step 3
    In another small bowl, combine bread crumbs, Parmesan, oil, and red pepper flakes. Sprinkle mixture on top of each scallop.
    Step 4
    Bake until tops are golden and scallops are translucent, 12 to 15 minutes.
    Step 5
    Spoon butter over tops and serve with lemon wedges.
    """
    let instructionEntryStringWithStepCapitalized =
    """
    STEP 1
    Preheat oven to 425°. Pat scallops dry with paper towels and place in a small baking dish. Season with salt and pepper.
    STEP 2
    In a small bowl, combine melted butter, garlic, and lemon juice. Pour all over scallops.
    STEP 3
    In another small bowl, combine bread crumbs, Parmesan, oil, and red pepper flakes. Sprinkle mixture on top of each scallop.
    STEP 4
    Bake until tops are golden and scallops are translucent, 12 to 15 minutes.
    STEP 5
    Spoon butter over tops and serve with lemon wedges.
    """
    let instructionEntryStringWithNumbersOnly = "1 Instruction step 1\n2 Instruction step 2\n3 Instruction step 3\n"
    
    override func setUp() {
        sut = RecipeCreatorViewModel(dataManager: DataManager.testing, networkController: NetworkController())
    }

    override func tearDown() {
        sut = nil
    }
/*
    func testParsingInstructionsWithNumbersAndDots() throws {
        
        sut.parseInstructions(input: instructionEntryStringWithNumbersAndDots)
        XCTAssert(sut.parsedInstructions.count == 3, " There should be 3 ingredients parsed")
        let first = try XCTUnwrap(sut.parsedInstructions.first)
        XCTAssert(first.text == "Instruction step 1", "first parsed instruction should be equal to 'Instruction step 1'")
    }
    
    func testParsingInstructionsWithNumbers() throws {
        
        sut.parseInstructions(input: instructionEntryStringWithNumbersOnly)
        XCTAssert(sut.parsedInstructions.count == 3, " There should be 3 ingredients parsed")
        let first = try XCTUnwrap(sut.parsedInstructions.first)
        XCTAssert(first.text == "Instruction step 1", "first parsed instruction should be equal to 'Instruction step 1'")
    }
    
    func testParsingInstructionsWithStep() {
        sut.parseInstructions(input: instructionEntryStringWithStep)
        print(sut.parsedInstructions)
        XCTAssert(sut.parsedInstructions.count == 5, " There should be 5 ingredients parsed")
        do {
            let first = try XCTUnwrap(sut.parsedInstructions.first)
            XCTAssert(first.text == "Instruction step 1.", "first parsed instruction should be equal to 'Instruction step 1.'")
        } catch {
            XCTFail("Failed to unwrap first parsed instruction")
        }
    }
*/
    
}
