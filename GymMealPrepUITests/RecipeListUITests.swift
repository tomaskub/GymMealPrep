//
//  RecipeListUITests.swift
//  GymMealPrepUITests
//
//  Created by Tomasz Kubiak on 7/16/23.
//

import XCTest

final class RecipeListUITests: XCTestCase {
    
    //MARK: INFORMATION ABOUT NAMING
    /*
     Naming structure: test_UnitOfWork_StateUnderTest_ExpectedBehaviour
     Naming structure: test_[Struct or class]_[UI component]_[expected result]
     Testing structure: Given, When, Then
     */

    var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        continueAfterFailure = false
        app.launch()
    }

    override func tearDown() {
        app = nil
    }

    func testExample() throws {
        

        
    }
}
