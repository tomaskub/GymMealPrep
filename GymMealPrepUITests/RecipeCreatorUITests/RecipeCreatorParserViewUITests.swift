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
    let recipeTitleInput = "Breakfast burrito"
    let ingredientsInput = "2 eggs\n2 bacon strips\n1 flour tortilla\n28 grams of cheddar cheese\n50 grams of green bell pepper"
    let instructionsInput = "1. Fry bacon strips and scramble the eggs \n2. Remove bacon and eggs, put shredded cheese on the pan. \n3. After the cheese melts, cover cheese with tortilla \n4. Flip the tortilla and put it on plate, top with the rest of ingredients. Roll the burrito.\n5. Put the burrito on the hot pan, seam side down. After 30 seconds remove and prepare for serving"
    
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
    
    func test_RecipeCreatorParserView_StaticTexts_DisplayCorrectAmountOfCells() {
        // Given
        navigateToRecipeCreatorView()
        fillInDataOnCreatorView()
        
        // When
        advanceStage()
        
        // Then
        let predicate = NSPredicate(format: "exists == true")
        let expectations = [
            expectation(for: predicate, evaluatedWith: app.staticTexts["5 Ingredients:"])]
        let result = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(result, .completed)
    }
    
    func test_RecipeCreatorParserView_IngredientRows_displayInputText() {
        // Given
        navigateToRecipeCreatorView()
        fillInDataOnCreatorView()
        
        // When
        advanceStage()
        
        // Then
        let predicate = NSPredicate(format: "exists == true")
        var expectations = [XCTestExpectation]()
        let labels = ingredientsInput.components(separatedBy: "\n")
        for label in labels {
            expectations.append(expectation(for: predicate, evaluatedWith: app.collectionViews.staticTexts[label]))
        }
        
        let result = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "All input text should exist in cells")
    }
    // This test relies on call to api - it should be replaced by the mock configured to run when -UITests argument is passed on launch
    func test_RecipeCreatorParserView_IngredientRows_navigatesToIngredientHostViewOnTap() {
        // Given
        navigateToRecipeCreatorView()
        fillInDataOnCreatorView()
        advanceStage()
        
        // When
        app.cells.staticTexts["2 eggs"].tap()
        
        // Then
        let navigationTitle = app.navigationBars.staticTexts["Change match"]
        let result = navigationTitle.waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "Navigation title 'Change match' should exist")
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
