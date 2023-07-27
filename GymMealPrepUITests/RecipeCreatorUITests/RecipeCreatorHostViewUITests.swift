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
    let recipeTitleInput = "Breakfast burrito"
    let ingredientsInput = "2 eggs\n2 bacon strips\n1 flour tortilla\n28 grams of cheddar cheese\n50 grams of green bell pepper"
    let instructionsInput = "1. Fry bacon strips and scramble the eggs \n2. Remove bacon and eggs, put shredded cheese on the pan. \n3. After the cheese melts, cover cheese with tortilla \n4. Flip the tortilla and put it on plate, top with the rest of ingredients. Roll the burrito.\n5. Put the burrito on the hot pan, seam side down. After 30 seconds remove and prepare for serving"
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
            expectation(for: predicate, evaluatedWith: app.staticTexts["Save and open"])]
        let result = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "Static texts 'Save and exit' and 'Save and open' should exist")
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
    
    func fillInDataOnCreatorView() {
        tapToolTips()
        enterData()
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
        titleTextField.typeText(recipeTitleInput)
        
        nextButton.tap()
        waitUtilElementHasKeyboardFocus(element: ingredientsTextField, timeout: standardTimeout).typeText(ingredientsInput)
        
        nextButton.tap()
        waitUtilElementHasKeyboardFocus(element: instructionsTextField, timeout: standardTimeout).typeText(instructionsInput)
        
        finishButton.tap()
    }
    
}
