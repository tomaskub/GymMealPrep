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
    """
    1. Instruction step 1\n
    2. Instruction step 2\n
    3. Instruction step 3\n
    """
    
    override func setUp() {
        sut = RecipeCreatorViewModel()
    }

    override func tearDown() {
        sut = nil
    }

    func testExample() throws {
        
    }
}
