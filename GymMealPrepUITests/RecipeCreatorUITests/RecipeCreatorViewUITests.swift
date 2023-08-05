//
//  RecipeCreatorUITests.swift
//  GymMealPrepUITests
//
//  Created by Tomasz Kubiak on 7/27/23.
//

import XCTest

final class RecipeCreatorViewUITests: XCTestCase {

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
        helper = nil
        app = nil
    }
    
    func test_RecipeCreatorView_Tooltips_shouldBePresent() {
        // Given
        helper.navigateToRecipeCreatorView()
        
        // Then
        let ingredientsToolTip = app.staticTexts["ingredients-tool-tip"]
        let instructionToolTip = app.staticTexts["instructions-tool-tip"]
        
        let predicate = NSPredicate(format: "exists == true")
        let expectations = [
            expectation(for: predicate, evaluatedWith: ingredientsToolTip),
            expectation(for: predicate, evaluatedWith: instructionToolTip)
        ]
        let result = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "Tooltips for ingredients and isntructions should exist")
    }
    
    func test_RecipeCreatorView_Tooltips_shouldDissapearAfterTap() {
        // Given
        helper.navigateToRecipeCreatorView()
        
        // When
        helper.tapToolTips()

        // Then
        let ingredientsToolTip = app.staticTexts["ingredients-tool-tip"]
        let instructionToolTip = app.staticTexts["instructions-tool-tip"]
        
        let predicate = NSPredicate(format: "exists == false")
        let expectations = [
            expectation(for: predicate, evaluatedWith: ingredientsToolTip),
            expectation(for: predicate, evaluatedWith: instructionToolTip)
        ]
        let result = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "Tooltips for ingredients and isntructions should not exist after tap")
        
    }
    
    func test_RecipeCreatorView_KeyboardToolBarButtons_shouldDisplayCorrectly_whenRecipeTitleTap() {
        // Given
        helper.navigateToRecipeCreatorView()
        helper.tapToolTips()
        
        // When
        app.textFields["recipe-title-text-field"].tap()
        
        // Then
        let nextButton = app.toolbars["Toolbar"].buttons["Next"]
        let backButton = app.toolbars["Toolbar"].buttons["Back"]
        let expectations = [
            expectation(for: NSPredicate(format: "exists == true"), evaluatedWith: nextButton),
            expectation(for: NSPredicate(format: "exists == false"), evaluatedWith: backButton)]
        let result = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "Next button should exist, back button should not exist")
    }
    
    func test_RecipeCreatorView_KeyboardToolBarBackButton_shouldExistAfterTapOnNext() {
        // Given
        helper.navigateToRecipeCreatorView()
        helper.tapToolTips()
        
        // When
        app.textFields["recipe-title-text-field"].tap()
        app.toolbars["Toolbar"].buttons["Next"].tap()
        
        // Then
        let result = app.toolbars["Toolbar"].buttons["Back"]
            .waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "Back button should exist")
    }
    
    func test_RecipeCreatorView_keyboardToolbarNextButton_shouldSwitchFocus() {
        // Given
        helper.navigateToRecipeCreatorView()
        helper.tapToolTips()
        
        // When
        app.textFields["recipe-title-text-field"].tap()
        app.toolbars["Toolbar"].buttons["Next"].tap()
        
        // Then
        let ingredientsTextField = app.scrollViews.textViews["ingredients-text-field"]
        let focusExpectation = expectation(for: NSPredicate(format: "hasKeyboardFocus == true"), evaluatedWith: ingredientsTextField)
        let result = XCTWaiter.wait(for: [focusExpectation], timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "Ingredients text field should have focus")
    }
    
    func test_RecipeCreatorView_keyboardToolBarBackButton_shouldSwitchFocus() {
        // Given
        helper.navigateToRecipeCreatorView()
        helper.tapToolTips()
        let titleTextField = app.scrollViews.textFields["recipe-title-text-field"]
        
        // When
        titleTextField.tap()
        app.toolbars["Toolbar"].buttons["Next"].tap()
        app.toolbars["Toolbar"].buttons["Back"].tap()
        
        // Then
        let focusExpectation = expectation(for: NSPredicate(format: "hasKeyboardFocus == true"), evaluatedWith: titleTextField)
        let result = XCTWaiter.wait(for: [focusExpectation], timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "Title text field should have focus")
    }
    
    func test_RecipeCreatorView_TextFields_shouldHoldData() {
        // Given
        helper.navigateToRecipeCreatorView()
        helper.tapToolTips()
        
        // When
        helper.enterData()
        
        // Then
        let titleTextField = app.scrollViews.textFields["recipe-title-text-field"]
        let ingredientsTextField = app.scrollViews.textViews["ingredients-text-field"]
        let instructionsTextField = app.scrollViews.textViews["instructions-text-field"]
        
        
        XCTAssertEqual(titleTextField.value as? String, RecipeCreatorUITestsHelper.RecipeInputStrings.recipeTitleInput, "The recipe title should be the same as input given")
        XCTAssertEqual(ingredientsTextField.value as? String, RecipeCreatorUITestsHelper.RecipeInputStrings.ingredientsInput, "The recipe ingredients should be the same as input given")
        XCTAssertEqual(instructionsTextField.value as? String, RecipeCreatorUITestsHelper.RecipeInputStrings.instructionsInput, "The recipe instructions should be the same as input given")
    }
    
}
