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
    
    // MARK: NAVIGATION HELPERS
    func navigateToRecipeCreatorViewFromText() {
        app.tabBars["Tab Bar"].buttons["Recipes"].tap()
        let recipiesNavigationBar = app.navigationBars["Recipes"]
        recipiesNavigationBar.images["expand-button"].tap()
        _ = recipiesNavigationBar.buttons["Add from text"].waitForExistence(timeout: 1)
        recipiesNavigationBar.buttons["Add from text"].tap()
    }
    
    func navigateToRecipeCreatorViewFromWeb() {
        app.tabBars["Tab Bar"].buttons["Recipes"].tap()
        let recipiesNavigationBar = app.navigationBars["Recipes"]
        recipiesNavigationBar.images["expand-button"].tap()
        _ = recipiesNavigationBar.buttons["Add from web"].waitForExistence(timeout: 1)
        recipiesNavigationBar.buttons["Add from web"].tap()
    }
    
    func navigateToRecipeCreatorConfirmationView() {
        navigateToRecipeCreatorViewFromText()
        tapToolTips()
        enterData(recipeTitle: "TEST", recipeIngredients: "TEST", recipeInstructions: "TEST")
        advanceStage(numberOfStages: 3)
    }
    
    func advanceStage(numberOfStages i: Int = 1) {
        for _ in 0..<i {
            app.staticTexts["advance-stage-button"].tap()
        }
    }
    
    // MARK: TAP ELEMENT FUNCTIONS
    func goToPreviousStage() {
        app.images["back-button"].tap()
    }
    
    func goToNextStage() {
        app.images["next-button"].tap()
    }
    
    func tapToolTips() {
        app.staticTexts["ingredients-tool-tip"].firstMatch.tap()
        app.staticTexts["instructions-tool-tip"].firstMatch.tap()
    }
    
    func tapAddInstructionButton() {
        app.collectionViews.cells.images["add-instruction-button"].tap()
    }
    
    func tapAddPhotoButton() {
        app.collectionViews.buttons["add-change-photo"].tap()
    }
    
    func tapDeletePhotoButton() {
        app.collectionViews.buttons["delete-photo"].tap()
    }
    
    func tapSaveAndOpenButton() {
        app.staticTexts["Save and open"].tap()
    }
    
    // MARK: INPUT DATA FUNCTIONS
    func enterLink(link: String? = nil) {
        if let _link = link {
            let linkTextField = app.scrollViews.textFields["recipe-link-text-field"]
            linkTextField.tap()
            linkTextField.typeText(_link)
        }
    }
    /// Enter data in input text field on recipe creator view
    /// To work properly it needs tool tips to not exist
    func enterData(recipeTitle: String? = RecipeInputStrings.recipeTitleInput,
                   recipeIngredients: String? = RecipeInputStrings.ingredientsInput,
                   recipeInstructions: String? = RecipeInputStrings.instructionsInput) {
        
        let titleTextField = app.scrollViews.textFields["recipe-title-text-field"]
        let ingredientsTextField = app.scrollViews.textViews["ingredients-text-field"]
        let instructionsTextField = app.scrollViews.textViews["instructions-text-field"]
        let finishButton = app.toolbars["Toolbar"].buttons["Finish"]
        
        if let recipeTitle {
            titleTextField.tap()
            titleTextField.typeText(recipeTitle)
        }
        if let recipeIngredients {
            ingredientsTextField.tap()
            ingredientsTextField.typeText(recipeIngredients)
        }
        if let recipeInstructions {
            instructionsTextField.tap()
            instructionsTextField.typeText(recipeInstructions)
        }
        finishButton.tap()
    }
    
    func enterCookingTimes(cookingTime: String, preparingTime: String, waitingTime: String) {
        let cookingTimeTextField = app.collectionViews.textFields["cooking-time-text-field"]
        let preparingTimeTextField = app.collectionViews.textFields["preparing-time-text-field"]
        let waitingTimeTextField = app.collectionViews.textFields["waiting-time-text-field"]
        
        cookingTimeTextField.tap()
        cookingTimeTextField.typeText("15")
        
        preparingTimeTextField.tap()
        preparingTimeTextField.typeText("25")
        
        waitingTimeTextField.tap()
        waitingTimeTextField.typeText("35")
    }
    
    func addTags(tagTexts: [String]) {
        for tagText in tagTexts {
            addTag(tagText: tagText)
        }
        app.keyboards.buttons["Return"].tap()
    }
    
    func addTag(tagText: String){
        let inputTextField = app.collectionViews.cells.containing(.button, identifier: "Add").textFields["Add new tag"]
        inputTextField.tap()
        inputTextField.typeText(tagText)
        app.collectionViews.buttons["Add"].tap()
    }
    
    func addPhoto(photoId: String = "Photo, August 08, 2012, 11:29 PM") {
        app.collectionViews.buttons["add-change-photo"].tap()
        app.scrollViews.images[photoId].tap()
    }
    
}
