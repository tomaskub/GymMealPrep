//
//  RecipeCreatorUITests.swift
//  GymMealPrepUITests
//
//  Created by Tomasz Kubiak on 7/12/23.
//

import XCTest

final class RecipeCreatorHostViewUITests: XCTestCase {
    
    //MARK: INFORMATION ABOUT NAMING
    /*
     Naming structure: test_UnitOfWork_StateUnderTest_ExpectedBehaviour
     Naming structure: test_[Struct or class]_[UI component]_[expected result]
     Testing structure: Given, When, Then
     */

    var app: XCUIApplication!
    
    //MARK: static input properties
    
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
    
    func test_RecipeCreatorHostView_stageControl_exists() {
        // Given
        navigateToRecipeCreatorView()
        let matchIngredientsButton = app.staticTexts["Match ingredients"]
        
        // Then
        let result = matchIngredientsButton.waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "'Match ingredients' buton should exits")
    }
    
    func test_RecipeCreatorHostView_StageControls_navigatesToParserViewOnTap() {
        // Given
        navigateToRecipeCreatorView()
        let matchIngredientsButton = app.staticTexts["Match ingredients"]
        let matchIngredientsTitle = app.navigationBars.staticTexts["Match ingredients"]
        
        // When
        matchIngredientsButton.tap()
        
        // Then
        let result = matchIngredientsTitle.waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "Navigation titile 'Match ingredients' should exist")
    }
    
    func test_RecipeCreatorHostView_StageControls_BackButtonAppearsOnAdvancedStage() {
        // Given
        navigateToRecipeCreatorView()
        let matchIngredientsButton = app.staticTexts["Match ingredients"]
        let backButton = app.images["back-button"]
        
        // When
        matchIngredientsButton.tap()
        
        // Then
        let result = backButton.waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "Back button should exist")
    }
    
    func test_RecipeCreatorHostView_StageControls_ForwardButtonShouldExistAfterBackButtonTap() {
        // Given
        navigateToRecipeCreatorView()
        let matchIngredientsButton = app.staticTexts["Match ingredients"]
        let backButton = app.images["back-button"]
        let nextButton = app.images["next-button"]
        
        // When
        matchIngredientsButton.tap()
        _ = backButton.waitForExistence(timeout: standardTimeout)
        backButton.tap()
        
        // Then
        let result = nextButton.waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "Next button should exist")
    }

    func test_RecipeCreatorHostView_StageControls_displayCorrectButtonLabelsForParserView() {
        // Given
        navigateToRecipeCreatorView()
        let advanceStageButton = app.staticTexts["advance-stage-button"]
        
        // When
        advanceStageButton.tap()
        
        // Then
        let result = app.staticTexts["Confirm ingredients"].waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "'Confirm ingredients' static text should exist")
    }
    func test_RecipeCreatorHostView_StageControls_displayCorrectButtonLabelsForInstructionView() {
        // Given
        navigateToRecipeCreatorView()
        let advanceStageButton = app.staticTexts["advance-stage-button"]
        
        // When
        advanceStageButton.tap()
        advanceStageButton.tap()
        
        // Then
        let result = app.staticTexts["Confirm instructions"].waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "'Confirm instructions' static text should exist")
    }
    func test_RecipeCreatorHostView_StageControls_displayCorrectButtonLabelsForConfirmationView() {
        // Given
        navigateToRecipeCreatorView()
        let advanceStageButton = app.staticTexts["advance-stage-button"]
        
        // When
        advanceStageButton.tap()
        advanceStageButton.tap()
        advanceStageButton.tap()
        
        // Then
        let predicate = NSPredicate(format: "exists == true")
        let expectations = [
            expectation(for: predicate, evaluatedWith: app.staticTexts["Save and exit"]),
            expectation(for: predicate, evaluatedWith: app.staticTexts["Save and open"]),
            expectation(for: NSPredicate(format: "exists == false"), evaluatedWith: app.images["next-button"])]
        let result = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "Static texts 'Save and exit' and 'Save and open' should exist. Next button should not exist")
    }
}

//MARK: HELPER FUNCTIONS
extension RecipeCreatorHostViewUITests {
    
    func navigateToRecipeCreatorView() {
        app.tabBars["Tab Bar"].buttons["Recipes"].tap()
        let recipiesNavigationBar = app.navigationBars["Recipes"]
        recipiesNavigationBar.images["Back"].tap()
        _ = recipiesNavigationBar.buttons["Add from text"].waitForExistence(timeout: 1)
        recipiesNavigationBar.buttons["Add from text"].tap()
    }
}
