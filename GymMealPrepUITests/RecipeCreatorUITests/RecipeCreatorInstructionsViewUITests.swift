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
    //Note - the test has to add ingredients otherwise the app will not parse instructions 
    func test_RecipeCreatorInstructionsView_instructionCells_areShowingWithInputFromCreator() {
        // Given
        navigateToRecipeCreatorView()
        enterData()
        
        // When
        advanceStage()
        advanceStage()
        
        // Then
        var expectedTextFields = [String]()
        
        for string in instructionsInput.components(separatedBy: "\n") {
            expectedTextFields.append(String(string.dropFirst(3)))
        }
        
        let predicate = NSPredicate(format: "exists == true")
        var expectations = [XCTestExpectation]()
        for expectedTexField in expectedTextFields {
            expectations.append(expectation(for: predicate, evaluatedWith: app.collectionViews.cells.textViews[expectedTexField]))
        }
        let result = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "All instruction input should be translated into seperate instruction rows")
    }
    
    func test_RecipeCreatorInstructionsView_instructionCell_showDeleteButton_WhenSwipedLeft() {
        // Given
        navigateToRecipeCreatorView()
        advanceStage()
        advanceStage()
        app.collectionViews.cells.images["add-instruction-button"].tap()
        
        // When
        _ = XCTWaiter.wait(for: [expectation(for: NSPredicate(format: "count == 2"), evaluatedWith: app.collectionViews.cells)])
        app.collectionViews.cells.firstMatch.swipeLeft()
        
        // Then
        let result = app.collectionViews.buttons["Delete"].waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result)
    }
    
    func test_RecipeCreatorInstructionsView_instructionCell_isRemovedOnDeleteButtonTap() {
        // Given
        navigateToRecipeCreatorView()
        advanceStage()
        advanceStage()
        app.collectionViews.cells.images["add-instruction-button"].tap()
        _ = XCTWaiter.wait(for: [expectation(for: NSPredicate(format: "count == 2"), evaluatedWith: app.collectionViews.cells)], timeout: standardTimeout)
        
        // When
        app.collectionViews.cells.firstMatch.swipeLeft()
        app.collectionViews.buttons["Delete"].tap()
        
        // Then
        let result = XCTWaiter.wait(for: [expectation(for: NSPredicate(format: "count == 1"), evaluatedWith: app.collectionViews.cells)], timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "After delete button is tapped on cell, the count of cells should be 1")
    }
    
    func test_RecipeCreatorInstructionsView_instructionCell_isUpdatingStepTextOnMove() {
        // Given
        navigateToRecipeCreatorView()
        enterData()
        advanceStage()
        advanceStage()
        let firstCell = app.collectionViews.cells.firstMatch
        // When
        app.collectionViews.cells.element(boundBy: 3).press(forDuration: 0.5, thenDragTo: firstCell)
        // Then
        let result = app.collectionViews.cells.element(boundBy: 0).staticTexts["1"].waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "On first row static text '1' should exist")
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
        let ingredientsTextField = recipeTitleElementsQuery.textViews["IngredientsTextField"]
        let instructionsTextField = recipeTitleElementsQuery.textViews["InstructionsTextField"]
        let nextButton = app.toolbars["Toolbar"].buttons["Next"]
        let finishButton = app.toolbars["Toolbar"].buttons["Finish"]
        
        titleTextField.tap()
        
        nextButton.tap()
        waitUtilElementHasKeyboardFocus(element: ingredientsTextField, timeout: standardTimeout).typeText(ingredientsInput)
        
        nextButton.tap()
        waitUtilElementHasKeyboardFocus(element: instructionsTextField, timeout: standardTimeout).typeText(instructionsInput)
        finishButton.tap()
    }
}
