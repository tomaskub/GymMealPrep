//
//  RecipeCreatorUITestsHelper.swift
//  GymMealPrepUITests
//
//  Created by Tomasz Kubiak on 8/4/23.
//

import XCTest
/// This is a class that can handle the interactions with RecipeCreator views
final class RecipeCreatorUITestsHelper {
    
    struct RecipeInputStrings {
        static let recipeTitleInput: String = "Breakfast burrito"
        static let ingredientsInput: String = "2 eggs\n2 bacon strips\n1 flour tortilla\n28 grams of cheddar cheese\n50 grams of green bell pepper"
        static let instructionsInput: String = "1. Fry bacon strips and scramble the eggs \n2. Remove bacon and eggs, put shredded cheese on the pan. \n3. After the cheese melts, cover cheese with tortilla \n4. Flip the tortilla and put it on plate, top with the rest of ingredients. Roll the burrito.\n5. Put the burrito on the hot pan, seam side down. After 30 seconds remove and prepare for serving"
    }
    
    var app: XCUIApplication!
    
    init(forApplication: XCUIApplication!) {
        self.app = forApplication
    }
    
    func navigateToRecipeCreatorView() {
        app.tabBars["Tab Bar"].buttons["Recipes"].tap()
        let recipiesNavigationBar = app.navigationBars["Recipes"]
        recipiesNavigationBar.images["Back"].tap()
        _ = recipiesNavigationBar.buttons["Add from text"].waitForExistence(timeout: 1)
        recipiesNavigationBar.buttons["Add from text"].tap()
    }
    
    func advanceStage(numberOfStages i: Int = 1) {
        for _ in 0..<i {
            app.staticTexts["advance-stage-button"].tap()
        }
    }
    
    func goToLastStage() {
        app.images["back-button"].tap()
    }
    
    func goToNextStage() {
        app.images["next-button"].tap()
    }
    
    func tapToolTips() {
        app.staticTexts["ingredients-tool-tip"].firstMatch.tap()
        app.staticTexts["instructions-tool-tip"].firstMatch.tap()
    }
    
    func enterData(recipeTitle: String = RecipeInputStrings.recipeTitleInput,
                   recipeIngredients: String = RecipeInputStrings.ingredientsInput,
                   recipeInstructions: String = RecipeInputStrings.instructionsInput) {
        
        let titleTextField = app.scrollViews.textFields["recipe-title-text-field"]
        let ingredientsTextField = app.scrollViews.textViews["ingredients-text-field"]
        let instructionsTextField = app.scrollViews.textViews["instructions-text-field"]
        let finishButton = app.toolbars["Toolbar"].buttons["Finish"]
        
        titleTextField.tap()
        titleTextField.typeText(recipeTitle)
        
        ingredientsTextField.tap()
        ingredientsTextField.typeText(recipeIngredients)
        
        instructionsTextField.tap()
        instructionsTextField.typeText(recipeInstructions)
        
        finishButton.tap()
    }
    
    
}
