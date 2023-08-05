//
//  RecipeCreatorUserWorkflowUITests.swift
//  GymMealPrepUITests
//
//  Created by Tomasz Kubiak on 8/2/23.
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
    
    func test_RecipeCreator_UserAddingRecipeFromText() {
        // Given
        navigateToRecipeCreatorView()
        tapToolTips()
        enterData()
        advanceStage()
        advanceStage()
        advanceStage()
        addPhoto()
        typeInCookingTimes()
        addTags(tagsText: tagsInput())
        // When
        saveAndOpen()
        // Then
        let expectations = checkInputDataOnRecipeDetailView()
        let result = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "Basic elements should exist")
    }
}

extension RecipeCreatorUITests {
    func checkInputDataOnRecipeDetailView() -> [XCTestExpectation]{
        let recipeImage = app.collectionViews.images.firstMatch
        let recipeTitle = app.collectionViews.cells.staticTexts[recipeTitleInput()]
        let tagStaticTexts: [XCUIElement] = {
           var array = [XCUIElement]()
            for text in tagsInput() {
                let staticText = app.collectionViews.staticTexts[text]
                array.append(staticText)
            }
            return array
        }()
        let elementsToEvaluate: [XCUIElement] = {
            var array = [XCUIElement]()
            array.append(recipeImage)
            array.append(recipeTitle)
            array.append(contentsOf: tagStaticTexts)
            return array
        }()
        let predicate = NSPredicate(format: "exists == true")
        var expectations = [XCTestExpectation]()
        for element in elementsToEvaluate {
            expectations.append( expectation(for: predicate, evaluatedWith: element))
        }
        return expectations
    }
    func typeInCookingTimes() {
        let cookingTimeTextField = app.collectionViews.textFields["cooking-time-text-field"]
        let preparingTimeTextField = app.collectionViews.textFields["preparing-time-text-field"]
        let waitingTimeTextField = app.collectionViews.textFields["waiting-time-text-field"]
        
        cookingTimeTextField.tap()
        waitUntilElementHasKeyboardFocus(element: cookingTimeTextField, timeout: standardTimeout).typeText("15")
        preparingTimeTextField.tap()
        waitUntilElementHasKeyboardFocus(element: preparingTimeTextField, timeout: standardTimeout).typeText("10")
        waitingTimeTextField.tap()
        waitUntilElementHasKeyboardFocus(element: waitingTimeTextField, timeout: standardTimeout).typeText("0")
    }
    
    func saveAndOpen() {
        app.staticTexts["Save and open"].tap()
    }
    
    func addTags(tagsText: [String]) {
        for text in tagsText {
            addTag(text: text)
        }
        app.keyboards.buttons["Return"].tap()
        
    }
    func addTag(text: String) {
        let tagTextField = app.collectionViews.cells.textFields["Add new tag"]
        tagTextField.tap()
        waitUntilElementHasKeyboardFocus(element: tagTextField, timeout: standardTimeout).typeText(text)
        app.collectionViews.cells.buttons["Add"].tap()
    }
    func addPhoto() {
        app.collectionViews.buttons["add-change-photo"].tap()
        app.scrollViews.images["Photo, August 08, 2012, 11:29 PM"].tap()
    }
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
        waitUntilElementHasKeyboardFocus(element: ingredientsTextField, timeout: standardTimeout).typeText(ingredientsInput())
        
        nextButton.tap()
        waitUntilElementHasKeyboardFocus(element: instructionsTextField, timeout: standardTimeout).typeText(instructionsInput())
        
        finishButton.tap()
    }
    
    func advanceStage() {
        app.staticTexts["advance-stage-button"].tap()
    }
    
    func recipeTitleInput() -> String {
        return "Breakfast burrito"
    }
    
    func ingredientsInput() -> String {
        return "2 eggs\n2 bacon strips\n1 flour tortilla\n28 grams of cheddar cheese\n50 grams of green bell pepper"
    }
    
    func instructionsInput() -> String {
        return "1. Fry bacon strips and scramble the eggs \n2. Remove bacon and eggs, put shredded cheese on the pan. \n3. After the cheese melts, cover cheese with tortilla \n4. Flip the tortilla and put it on plate, top with the rest of ingredients. Roll the burrito.\n5. Put the burrito on the hot pan, seam side down. After 30 seconds remove and prepare for serving"
    }
    
    func tagsInput() -> [String] {
        ["breakfast", "mexican", "burrito", "freezer-friendly"]
    }
}
