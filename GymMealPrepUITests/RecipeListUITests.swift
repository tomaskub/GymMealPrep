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
    
    func test_RecipeList_UIComponents_arePresent() throws {
        // Given
        navigateToRecipeList()
        
        let recipesNavigationBar = app.navigationBars["Recipes"]
        let navTitleText = recipesNavigationBar.staticTexts["Recipes"]
        let addButton = recipesNavigationBar.buttons["Add"]
        let chevronLeftButton = recipesNavigationBar.images["Back"]
        let addFromTextButton = recipesNavigationBar.buttons["Add from text"]
        
        // When
        chevronLeftButton.tap()
        
        //Then
        let existsPredicate = NSPredicate(format: "exists == true")
        let expectations = [
        expectation(for: existsPredicate, evaluatedWith: navTitleText),
        expectation(for: existsPredicate, evaluatedWith: addButton),
        expectation(for: existsPredicate, evaluatedWith: chevronLeftButton),
        expectation(for: existsPredicate, evaluatedWith: addFromTextButton)
        ]
        let testResult = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(testResult, .completed, "All of the elements should exists")
    }
}

extension RecipeListUITests {
    
    func navigateToRecipeList() {
        app.tabBars["Tab Bar"].buttons["Recipes"].tap()
    }
}
