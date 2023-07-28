//
//  RecipeCreatorParserViewUITests.swift
//  GymMealPrepUITests
//
//  Created by Tomasz Kubiak on 7/27/23.
//

import XCTest

final class RecipeCreatorParserViewUITests: XCTestCase {
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
        app.launchArguments = ["-UITests"]
        app.launch()
    }

    override func tearDown() {
        app = nil
    }
    
    func test_RecipeCreatorParserView_StaticTexts_Shows0CellsWhenNoIngredientsToParse() {
        // Given
        navigateToRecipeCreatorView()
        
        // When
        advanceStage()
        
        // Then
        let navigationTitle = app.navigationBars.staticTexts["Match ingredients"]
        let ingredientCountText = app.collectionViews.staticTexts["0 Ingredients:"]
        
        let predicate = NSPredicate(format: "exists == true")
        let expectations = [
        expectation(for: predicate, evaluatedWith: navigationTitle),
        expectation(for: predicate, evaluatedWith: ingredientCountText)]
        let result = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "Navigation text 'Match ingredients' and summary text '0 Ingredients:' should exist")
    }
}

extension RecipeCreatorParserViewUITests {
    
    func advanceStage() {
        app.staticTexts["advance-stage-button"].tap()
    }
    
    func navigateToRecipeCreatorView() {
        app.tabBars["Tab Bar"].buttons["Recipes"].tap()
        let recipiesNavigationBar = app.navigationBars["Recipes"]
        recipiesNavigationBar.images["Back"].tap()
        _ = recipiesNavigationBar.buttons["Add from text"].waitForExistence(timeout: 1)
        recipiesNavigationBar.buttons["Add from text"].tap()
    }
}
