//
//  RecipeCreatorUITests.swift
//  GymMealPrepUITests
//
//  Created by Tomasz Kubiak on 7/12/23.
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
    
    //MARK: static input properties
    let recipeTitleInput = "Breakfast burrito"
    let ingredientsInput = "2 eggs\n2bacon strips\n1flour tortilla\n28 grams of cheddar cheese\n50 grams of green bell pepper"
    let instructionsInput = "1. Fry bacon strips and scramble the eggs \n2. Remove bacon and eggs, put shredded cheese on the pan. \n3. After the cheese melts, cover cheese with tortilla \n4. Flip the tortilla and put it on plate, top with the rest of ingredients. Roll the burrito.\n5. Put the buttrito on the hot pan, seam side down. After 30 seconds remove and prepare for serving"
    let standardTimeout = 2.5
    
    override func setUp() {
        app = XCUIApplication()
        continueAfterFailure = false
        app.launch()
    }

    override func tearDown() {
        app = nil
    }
    
    func test_RecipeCreatorHostView_expandableButton_shouldExpandOnTap() throws {
        // Given
        navigateToRecipeList()
        
        // When
        let recipiesNavigationBar = app.navigationBars["Recipies"]
        recipiesNavigationBar/*@START_MENU_TOKEN@*/.images["Back"]/*[[".otherElements[\"Back\"].images[\"Back\"]",".images[\"Back\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        // Then
        let addFromTextButton = recipiesNavigationBar.buttons["Add from text"]
        let addFromTextButtonExists = addFromTextButton.waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(addFromTextButtonExists, "Button add from text should exist")
    }
    
    
    func test_RecipeCreatorHostView_Navigation_shouldNavigateToView() throws {
        // Given
        navigateToRecipeList()
        
        // When
        navigateToRecipeCreatorViewFromRecipeList()
        
        // Then
        let navigationTitleStaticText = app.navigationBars["Create recipe"].staticTexts["Create recipe"]
        let navigationTitleExists = navigationTitleStaticText.waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(navigationTitleExists, "Navigation titile should exist")
    }
    
    func test_RecipeCreatorView_Tooltips_shouldBePresent() throws {
        // Given
        navigateToRecipeList()
        
        // When
        navigateToRecipeCreatorViewFromRecipeList()
        
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
        let ingredientsTextField = recipeTitleElementsQuery.textViews["IngredientsTextField"]
//        let instructionsTextField = recipeTitleElementsQuery.textViews["InstructionsTextField"]
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
    
    // do not test performance in this suite of testing
    /*
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
     */
}
//MARK: HELPER FUNCTIONS
extension RecipeCreatorUITests {
    
    func navigateToRecipeCreatorView() {
        navigateToRecipeList()
        navigateToRecipeCreatorViewFromRecipeList()
    }
    
    func navigateToRecipeList() {
        app.tabBars["Tab Bar"].buttons["Recipes"].tap()
    }
    
    func navigateToRecipeCreatorViewFromRecipeList() {
        let recipiesNavigationBar = app.navigationBars["Recipies"]
        recipiesNavigationBar/*@START_MENU_TOKEN@*/.images["Back"]/*[[".otherElements[\"Back\"].images[\"Back\"]",".images[\"Back\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
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
}
