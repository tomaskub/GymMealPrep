//
//  RecipeCreatorInstructionsView.swift
//  GymMealPrepUITests
//
//  Created by Tomasz Kubiak on 7/27/23.
//

import XCTest

final class RecipeCreatorInstructionsViewUITests: XCTestCase {
    //MARK: INFORMATION ABOUT NAMING
    /*
     Naming structure: test_UnitOfWork_StateUnderTest_ExpectedBehaviour
     Naming structure: test_[Struct or class]_[UI component]_[expected result]
     Testing structure: Given, When, Then
     */
    var app: XCUIApplication!
    let standardTimeout = 2.5
    
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
    
    func test_RecipeCreatorInstructionsView_NavigationTitle_isDisplayed() {
        // Given
        navigateToRecipeCreatorView()
        
        // When
        advanceStage()
        advanceStage()
        
        // Then
        let title = app.navigationBars["Instructions"]
        let result = title.waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result,"'Instructions' navigation titile should exist")
    }
    
    func test_RecipeCreatorInstructionsView_AddInstructionsButton_exists() {
        // Given
        navigateToRecipeCreatorView()
        
        // When
        advanceStage()
        advanceStage()
        
        // Then
        let addButton = app.collectionViews.images["add-instruction-button"]
        let result = addButton.waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result,"'Add' button should exist")
    }
    
    func test_RecipeCreatorInstructionsView_AddInstructionsButton_AddsCellOnTap() {
        // Given
        navigateToRecipeCreatorView()
        advanceStage()
        advanceStage()
        let startingAmountOfCells = app.collectionViews.cells.count
        
        // When
        app.collectionViews.images["add-instruction-button"].tap()
        
        // Then
        let resultingAmountOfCells = app.collectionViews.cells.count
        XCTAssertEqual(resultingAmountOfCells - startingAmountOfCells, 1, "Difference in cell counts should be 1")
    }
    
    func test_RecipeCreatorInstructionsView_newInstructionCell_hasNumberAndTextField() {
        // Given
        navigateToRecipeCreatorView()
        advanceStage()
        advanceStage()
        
        // When
        app.collectionViews.images["add-instruction-button"].tap()
        
        // Then
        let predicate = NSPredicate(format: "exists == true")
        let expectations = [
            expectation(for: predicate, evaluatedWith: app.collectionViews.staticTexts["1"]),
            expectation(for: predicate, evaluatedWith: app.collectionViews.textFields.firstMatch)]
        let result = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "A number 1 text and text field should exist in collection view")
    }
    func test_RecipeCreatorInstructionsView_instructionCells_areShowingWithInputFromCreator() {
        // Given
        navigateToRecipeCreatorView()
        enterData()
        
        // When
        advanceStage()
        advanceStage()
        
        // Then
        let expectedTextFields: [String] = instructionsInput.components(separatedBy: "\n")
        let predicate = NSPredicate(format: "exists == true")
        var expectations = [XCTestExpectation]()
        for expectedTexField in expectedTextFields {
            expectations.append(expectation(for: predicate, evaluatedWith: app.collectionViews.cells.textFields[expectedTexField]))
        }
        let result = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "All instruction input should be translated into seperate instruction rows")
    }
}

// MARK: HELPER FUNCTIONS
extension RecipeCreatorInstructionsViewUITests {
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
    func enterData() {
        let recipeTitleElementsQuery = app.scrollViews.otherElements.containing(.textField, identifier:"Recipe title")
        let titleTextField = recipeTitleElementsQuery.textFields["Recipe title"]
        let instructionsTextField = recipeTitleElementsQuery.textViews["InstructionsTextField"]
        let nextButton = app.toolbars["Toolbar"].buttons["Next"]
        let finishButton = app.toolbars["Toolbar"].buttons["Finish"]
        
        titleTextField.tap()
        nextButton.tap()
        nextButton.tap()
        waitUtilElementHasKeyboardFocus(element: instructionsTextField, timeout: standardTimeout).typeText(instructionsInput)
        finishButton.tap()
    }
}
