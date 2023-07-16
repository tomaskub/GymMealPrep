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
    
    let standardTimeout = 2.5
    
    override func setUp() {
        app = XCUIApplication()
        continueAfterFailure = false
        app.launch()
    }

    override func tearDown() {
        app = nil
    }

    func test_RecipeList_TabBar_shouldNavigateToList() throws {
        // Given
        // captured in setup
        
        // When
        navigateToRecipeList()
        
        // Then
        let navTitleText = app.navigationBars["Recipes"].staticTexts["Recipes"]
        let result = navTitleText.waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "Recipe navigation title should exist")
    }
}

extension RecipeListUITests {
    
    func navigateToRecipeList() {
        app.tabBars["Tab Bar"].buttons["Recipes"].tap()
    }
}
