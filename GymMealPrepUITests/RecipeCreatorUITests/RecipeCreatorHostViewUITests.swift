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
    
}

//MARK: HELPER FUNCTIONS
extension RecipeCreatorHostViewUITests {
    
    func navigateToRecipeCreatorView() {
        navigateToRecipeList()
        navigateToRecipeCreatorViewFromRecipeList()
    }
    
    func navigateToRecipeList() {
        app.tabBars["Tab Bar"].buttons["Recipes"].tap()
    }
    
    func navigateToRecipeCreatorViewFromRecipeList() {
        let recipiesNavigationBar = app.navigationBars["Recipes"]
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
