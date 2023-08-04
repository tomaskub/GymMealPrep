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
    
    func test_RecipeCreatorHostView_stageControl_exists() {
        // Given
        helper.navigateToRecipeCreatorView()
        
        // Then
        let result = app.staticTexts["Match ingredients"]
            .waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "'Match ingredients' buton should exits")
    }
    
    func test_RecipeCreatorHostView_StageControls_navigatesToParserViewOnTap() {
        // Given
        helper.navigateToRecipeCreatorView()
        
        // When
        helper.advanceStage()
        
        // Then
        let result = app.navigationBars.staticTexts["Match ingredients"]
            .waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "Navigation titile 'Match ingredients' should exist")
    }
    
    func test_RecipeCreatorHostView_StageControls_BackButtonAppearsOnAdvancedStage() {
        // Given
        helper.navigateToRecipeCreatorView()
        
        // When
        helper.advanceStage()
        
        // Then
        let result = app.images["back-button"]
            .waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "Back button should exist")
    }
    
    func test_RecipeCreatorHostView_StageControls_ForwardButtonShouldExistAfterBackButtonTap() {
        // Given
        helper.navigateToRecipeCreatorView()
        helper.advanceStage()
        
        // When
        helper.goToLastStage()
        
        // Then
        let result = app.images["next-button"]
            .waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "Next button should exist")
    }

    func test_RecipeCreatorHostView_StageControls_displayCorrectButtonLabelsForParserView() {
        // Given
        helper.navigateToRecipeCreatorView()
        
        // When
        helper.advanceStage()
        
        // Then
        let result = app.staticTexts["Confirm ingredients"]
            .waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "'Confirm ingredients' static text should exist")
    }
    
    func test_RecipeCreatorHostView_StageControls_displayCorrectButtonLabelsForInstructionView() {
        // Given
        helper.navigateToRecipeCreatorView()
        
        // When
        helper.advanceStage(numberOfStages: 2)
        
        // Then
        let result = app.staticTexts["Confirm instructions"]
            .waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "'Confirm instructions' static text should exist")
    }
    
    func test_RecipeCreatorHostView_StageControls_displayCorrectButtonLabelsForConfirmationView() {
        // Given
        helper.navigateToRecipeCreatorView()
        
        // When
        helper.advanceStage(numberOfStages: 3)
        
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
