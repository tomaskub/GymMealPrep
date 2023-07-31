//
//  RecipeCreatorUITests.swift
//  GymMealPrepUITests
//
//  Created by Tomasz Kubiak on 7/27/23.
//

import XCTest

final class RecipeCreatorUITests: XCTestCase {

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
    
    func test_RecipeCreatorView_Tooltips_shouldBePresent() throws {
        // Given
        navigateToRecipeCreatorView()
        
        // Then
        let staticTextQuery = app.scrollViews.otherElements.containing(.textField, identifier:"RecipeTitleTextField").children(matching: .staticText)
        let ingredientsToolTipTextView = staticTextQuery.matching(identifier: "IngredientsToolTip").element(boundBy: 0)
        let instructionToolTipTextView = staticTextQuery.matching(identifier: "InstructionsToolTip").element(boundBy: 0)
        
        let ingredientsToolTipTextViewExists = ingredientsToolTipTextView.waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(ingredientsToolTipTextViewExists, "Tool tip for ingredients should exist")
        
        let instructionsToolTipTextViewExists = instructionToolTipTextView.waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(instructionsToolTipTextViewExists, "Tool tip for instructions should exist")
    }
    
    func test_RecipeCreatorView_Tooltips_shouldDissapearAfterTap() throws {
        // Given
        navigateToRecipeCreatorView()
        
        // When
        let staticTextQuery = app.scrollViews.otherElements.containing(.textField, identifier:"RecipeTitleTextField").children(matching: .staticText)
        let ingredientsToolTipTextView = staticTextQuery.matching(identifier: "IngredientsToolTip").element(boundBy: 0)
        let instructionToolTipTextView = staticTextQuery.matching(identifier: "InstructionsToolTip").element(boundBy: 0)
        ingredientsToolTipTextView.tap()
        instructionToolTipTextView.tap()
        
        // Then
        let expectationForIngredientsToolTipExistance = expectation(for: NSPredicate(format: "exists == false"), evaluatedWith: ingredientsToolTipTextView, handler: .none)
        let expectationForInstructionsToolTipExistance = expectation(for: NSPredicate(format: "exists == false"), evaluatedWith: instructionToolTipTextView, handler: .none)
        let testResult = XCTWaiter.wait(for: [expectationForIngredientsToolTipExistance, expectationForInstructionsToolTipExistance], timeout: standardTimeout)
        XCTAssertEqual(testResult, .completed, "Both tooltips should not exist after tapping")
    }
    
    func test_RecipeCreatorView_KeyboardToolBarNextButton_shouldExistOnTap() throws {
        // Given
        navigateToRecipeCreatorView()
        tapToolTips()
        
        // When
        let titleTextField  = app.scrollViews.otherElements.containing(.textField, identifier:"Recipe title").textFields["Recipe title"]
        titleTextField.tap()
        
        // Then
        let nextButton = app.toolbars["Toolbar"].buttons["Next"]
        let nextButtonExists = nextButton.waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(nextButtonExists, "Next button should exist")
    }
    
    func test_RecipeCreatorView_KeyboardToolBarBackButton_shouldNotExistOnTap() throws {
        // Given
        navigateToRecipeCreatorView()
        tapToolTips()
        
        // When
        let titleTextField  = app.scrollViews.otherElements.containing(.textField, identifier:"Recipe title").textFields["Recipe title"]
        titleTextField.tap()
        
        // Then
        let backButton = app.toolbars["Toolbar"].buttons["Back"]
        let expectationForBackButton = expectation(for: NSPredicate(format: "exists == false"), evaluatedWith: backButton)
        let testResult = XCTWaiter.wait(for: [expectationForBackButton], timeout: standardTimeout)
        XCTAssertEqual(testResult, .completed, "Back button should not exist")
    }
    
    func test_RecipeCreatorView_KeyboardToolBarBackButton_shouldExistAfterTapOnText() throws {
        // Given
        navigateToRecipeCreatorView()
        tapToolTips()
        
        // When
        let titleTextField  = app.scrollViews.otherElements.containing(.textField, identifier:"Recipe title").textFields["Recipe title"]
        titleTextField.tap()
        let nextButton = app.toolbars["Toolbar"].buttons["Next"]
        nextButton.tap()
        
        // Then
        let backButton = app.toolbars["Toolbar"].buttons["Back"]
        let backButtonExists = backButton.waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(backButtonExists, "Next button should exist")
    }
    
    func test_RecipeCreatorView_keyboardToolbarNextButton_shouldSwitchFocus() throws {
        // Given
        navigateToRecipeCreatorView()
        tapToolTips()
        
        // When
        let recipeTitleElementsQuery = app.scrollViews.otherElements.containing(.textField, identifier:"Recipe title")
        let titleTextField = recipeTitleElementsQuery.textFields["Recipe title"]
        let ingredientsTextField = recipeTitleElementsQuery.textViews["IngredientsTextField"]
        let nextButton = app.toolbars["Toolbar"].buttons["Next"]
        
        titleTextField.tap()
        nextButton.tap()
        
        // Then
        let focusExpectation = expectation(for: NSPredicate(format: "hasKeyboardFocus == true"), evaluatedWith: ingredientsTextField)
        let result = XCTWaiter.wait(for: [focusExpectation], timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "Ingredients text field should have focus")
    }
    
    func test_RecipeCreatorView_keyboardToolBarBackButton_shouldSwitchFocus() throws {
        // Given
        navigateToRecipeCreatorView()
        tapToolTips()
        
        // When
        let recipeTitleElementsQuery = app.scrollViews.otherElements.containing(.textField, identifier:"Recipe title")
        let titleTextField = recipeTitleElementsQuery.textFields["Recipe title"]
        let nextButton = app.toolbars["Toolbar"].buttons["Next"]
        let backButton = app.toolbars["Toolbar"].buttons["Back"]
        
        titleTextField.tap()
        nextButton.tap()
        backButton.tap()
        
        // Then
        let focusExpectation = expectation(for: NSPredicate(format: "hasKeyboardFocus == true"), evaluatedWith: titleTextField)
        let result = XCTWaiter.wait(for: [focusExpectation], timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "Title text field should have focus")
    }
    
    // This test coul go somewhere else possibly or be tested with parser view? 
    func test_RecipeCreatorView_TextFields_shouldHoldData() throws {
        // Given
        navigateToRecipeCreatorView()
        tapToolTips()
        let recipeTitleElementsQuery = app.scrollViews.otherElements.containing(.textField, identifier:"Recipe title")
        let titleTextField = recipeTitleElementsQuery.textFields["Recipe title"]
        let ingredientsTextField = recipeTitleElementsQuery.textViews["IngredientsTextField"]
        let instructionsTextField = recipeTitleElementsQuery.textViews["InstructionsTextField"]
        
        // When
        enterData()
        
        // Then
        XCTAssertEqual(titleTextField.value as? String, recipeTitleInput(), "The recipe title should be the same as input given")
        XCTAssertEqual(ingredientsTextField.value as? String, ingredientsInput(), "The recipe ingredients should be the same as input given")
        XCTAssertEqual(instructionsTextField.value as? String, instructionsInput(), "The recipe instructions should be the same as input given")
    }
    
}

// MARK: HELPER FUNCTIONS & STATIC INPUT PROPERTIES
extension RecipeCreatorUITests {
    
    func recipeTitleInput() -> String { return "Breakfast burrito" }
    func ingredientsInput() -> String { return "2 eggs\n2 bacon strips\n1 flour tortilla\n28 grams of cheddar cheese\n50 grams of green bell pepper" }
    func instructionsInput() -> String { return "1. Fry bacon strips and scramble the eggs \n2. Remove bacon and eggs, put shredded cheese on the pan. \n3. After the cheese melts, cover cheese with tortilla \n4. Flip the tortilla and put it on plate, top with the rest of ingredients. Roll the burrito.\n5. Put the burrito on the hot pan, seam side down. After 30 seconds remove and prepare for serving"}
    
    func navigateToRecipeCreatorView() {
        app.tabBars["Tab Bar"].buttons["Recipes"].tap()
        let recipiesNavigationBar = app.navigationBars["Recipes"]
        recipiesNavigationBar.images["Back"].tap()
        _ = recipiesNavigationBar.buttons["Add from text"].waitForExistence(timeout: 1)
        recipiesNavigationBar.buttons["Add from text"].tap()
    }
    
    func tapToolTips() {
        let staticTextQuery = app.scrollViews.otherElements.containing(.textField, identifier:"RecipeTitleTextField").children(matching: .staticText)
        let ingredientsToolTipTextView = staticTextQuery.matching(identifier: "IngredientsToolTip").element(boundBy: 0)
        let instructionToolTipTextView = staticTextQuery.matching(identifier: "InstructionsToolTip").element(boundBy: 0)
        ingredientsToolTipTextView.tap()
        instructionToolTipTextView.tap()
    }
    
    func enterData() {
        let recipeTitleElementsQuery = app.scrollViews.otherElements.containing(.textField, identifier:"Recipe title")
        let titleTextField = recipeTitleElementsQuery.textFields["Recipe title"]
        let ingredientsTextField = recipeTitleElementsQuery.textViews["IngredientsTextField"]
        let instructionsTextField = recipeTitleElementsQuery.textViews["InstructionsTextField"]
        let nextButton = app.toolbars["Toolbar"].buttons["Next"]
        let finishButton = app.toolbars["Toolbar"].buttons["Finish"]
        
        titleTextField.tap()
        titleTextField.typeText(recipeTitleInput())
        
        nextButton.tap()
        waitUtilElementHasKeyboardFocus(element: ingredientsTextField, timeout: standardTimeout).typeText(ingredientsInput())
        
        nextButton.tap()
        waitUtilElementHasKeyboardFocus(element: instructionsTextField, timeout: standardTimeout).typeText(instructionsInput())
        
        finishButton.tap()
    }
}
