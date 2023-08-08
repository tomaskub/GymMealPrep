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
    var helper: RecipeCreatorUITestsHelper!
    let standardTimeout = 2.5
    
    override func setUp() {
        app = XCUIApplication()
        helper = RecipeCreatorUITestsHelper(forApplication: app)
        continueAfterFailure = false
        app.launchArguments = ["-UITests"]
        app.launch()
    }

    override func tearDown() {
        app = nil
        helper = nil
    }
    
    func test_RecipeCreatorParserView_StaticTexts_Shows0CellsWhenNoIngredientsToParse() {
        // Given
        helper.navigateToRecipeCreatorView()
        helper.tapToolTips()
        helper.enterData(recipeTitle: "TEST", recipeIngredients: "TEST", recipeInstructions: "TEST")
        
        // When
        helper.advanceStage()
        
        // Then
        let navigationTitle = app.navigationBars.staticTexts["Match ingredients"]
        let ingredientCountText = app.collectionViews.staticTexts["0 Ingredients:"]
        let predicate = NSPredicate(format: "exists == true")
        let expectations = [
            expectation(for: predicate, evaluatedWith: navigationTitle),
            expectation(for: predicate, evaluatedWith: ingredientCountText)
        ]
        let result = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "Navigation text 'Match ingredients' and summary text '0 Ingredients:' should exist")
    }
    
    func test_RecipeCreatorParserView_StaticTexts_DisplayCorrectAmountOfCells() {
        // Given
        helper.navigateToRecipeCreatorView()
        helper.tapToolTips()
        helper.enterData()
        
        // When
        helper.advanceStage()
        
        // Then
        let expectations = [
            expectation(for: NSPredicate(format: "exists == true"), evaluatedWith: app.staticTexts["5 Ingredients:"]),
            expectation(for: NSPredicate(format: "count == 6"), evaluatedWith: app.collectionViews.cells)
        ]
        let result = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "Static text '5 Ingredients:' should exists, and view should have 6 cells")
        
    }
    
    func test_RecipeCreatorParserView_IngredientRows_displayInputText() {
        // Given
        helper.navigateToRecipeCreatorView()
        helper.tapToolTips()
        helper.enterData()
        
        // When
        helper.advanceStage()
        
        // Then
        let predicate = NSPredicate(format: "exists == true")
        var expectations = [XCTestExpectation]()
        let labels = RecipeCreatorUITestsHelper.RecipeInputStrings.ingredientsInput.components(separatedBy: "\n")
        for label in labels {
            expectations.append(expectation(for: predicate, evaluatedWith: app.collectionViews.staticTexts[label]))
        }
        
        let result = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "All input text should exist in cells")
    }
    // This test relies on call to api - it should be replaced by the mock configured to run when -UITests argument is passed on launch
    func test_RecipeCreatorParserView_IngredientRows_navigatesToIngredientHostViewOnTap() {
        // Given
        helper.navigateToRecipeCreatorView()
        helper.tapToolTips()
        helper.enterData()
        helper.advanceStage()
        
        // When
        app.cells.staticTexts["2 eggs"].tap()
        
        // Then
        let navigationTitle = app.navigationBars.staticTexts["Change match"]
        let result = navigationTitle.waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "Navigation title 'Change match' should exist")
    }
    
    // Test below will fail if we do not get an incorrect response from API call - we need to launch with no internet or sub the network request with a mock
    /*
    func test_RecipeCreatorParserView_IngredientRows_navigatesToIngredientHostViewOnTap() {
        // Given
        helper.navigateToRecipeCreatorView()
        helper.tapToolTips()
        helper.enterData()
        helper.advanceStage()
        
        // When
        app.cells.staticTexts["We failed to find the ingredient, tap to search for ingredient manually"].tap()
        
        // Then
        let navigationTitle = app.navigationBars.staticTexts["Correct match"]
        let result = navigationTitle.waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "Navigation title 'Correct match' should exist")
    }
    */
}

