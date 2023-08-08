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
    var helper: RecipeCreatorUITestsHelper!
    let standardTimeout = 2.5
    
    override func setUp() {
        app = XCUIApplication()
        helper = RecipeCreatorUITestsHelper(forApplication: app)
        continueAfterFailure = false
        app.launchArguments = ["-UITests"]
        app.launch()
    }

    override func tearDown() {
        app = nil
        helper = nil
    }
    
    func test_RecipeCreatorInstructionsView_NavigationTitle_isDisplayed() {
        // Given
        helper.navigateToRecipeCreatorView()
        helper.tapToolTips()
        helper.enterData(recipeTitle: "TEST", recipeIngredients: "TEST", recipeInstructions: "TEST")
        
        // When
        helper.advanceStage(numberOfStages: 2)
        
        // Then
        let result = app.navigationBars["Instructions"].waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result,"'Instructions' navigation titile should exist")
    }
    
    func test_RecipeCreatorInstructionsView_AddInstructionsButton_exists() {
        // Given
        helper.navigateToRecipeCreatorView()
        helper.tapToolTips()
        helper.enterData(recipeTitle: "TEST", recipeIngredients: "TEST", recipeInstructions: "TEST")
        
        // When
        helper.advanceStage(numberOfStages: 2)
        
        // Then
        let result = app.collectionViews.images["add-instruction-button"]
            .waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result,"'Add' button should exist")
    }
    
    func test_RecipeCreatorInstructionsView_AddInstructionsButton_AddsCellOnTap() {
        // Given
        helper.navigateToRecipeCreatorView()
        helper.tapToolTips()
        helper.enterData(recipeTitle: "TEST", recipeIngredients: "TEST", recipeInstructions: "TEST")
        helper.advanceStage(numberOfStages: 2)
        
        // When
        app.collectionViews.images["add-instruction-button"].tap()
        
        // Then
        XCTAssertEqual(app.collectionViews.cells.count, 3, "There should be 2 cells existing")
    }
    
    func test_RecipeCreatorInstructionsView_newInstructionCell_hasNumberAndTextField() {
        // Given
        helper.navigateToRecipeCreatorView()
        helper.tapToolTips()
        helper.enterData(recipeTitle: "TEST", recipeIngredients: "TEST", recipeInstructions: "TEST")
        helper.advanceStage(numberOfStages: 2)
        
        // When
        helper.tapAddInstructionButton()
        
        // Then
        let predicate = NSPredicate(format: "exists == true")
        let expectations = [
            expectation(for: predicate, evaluatedWith: app.collectionViews.staticTexts["1"]),
            expectation(for: predicate, evaluatedWith: app.collectionViews.textViews.firstMatch)]
        let result = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "A number 1 text and text field should exist in collection view")
    }

    func test_RecipeCreatorInstructionsView_instructionCells_areShowingWithInputFromCreator() {
        // Given
        helper.navigateToRecipeCreatorView()
        helper.tapToolTips()
        helper.enterData()
        
        // When
        helper.advanceStage(numberOfStages: 2)
        
        // Then
        var expectedTextFields = [String]()
        
        for string in RecipeCreatorUITestsHelper.RecipeInputStrings.instructionsInput.components(separatedBy: "\n") {
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
        helper.navigateToRecipeCreatorView()
        helper.tapToolTips()
        helper.enterData(recipeTitle: "TEST", recipeIngredients: "TEST", recipeInstructions: "TEST")
        helper.advanceStage(numberOfStages: 2)

        // When
        _ = XCTWaiter.wait(for: [expectation(for: NSPredicate(format: "count == 2"), evaluatedWith: app.collectionViews.cells)])
        app.collectionViews.cells.firstMatch.swipeLeft()
        
        // Then
        let result = app.collectionViews.buttons["Delete"].waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result)
    }
    
    func test_RecipeCreatorInstructionsView_instructionCell_isRemovedOnDeleteButtonTap() {
        // Given
        helper.navigateToRecipeCreatorView()
        helper.tapToolTips()
        helper.enterData(recipeTitle: "TEST", recipeIngredients: "TEST", recipeInstructions: "TEST")
        helper.advanceStage(numberOfStages: 2)
        
        _ = XCTWaiter.wait(for: [expectation(for: NSPredicate(format: "count == 2"), evaluatedWith: app.collectionViews.cells)], timeout: standardTimeout)
        
        // When
        app.collectionViews.cells.firstMatch.swipeLeft()
        app.collectionViews.buttons["Delete"].tap()
        
        // Then
        let result = XCTWaiter.wait(for: [expectation(for: NSPredicate(format: "count == 1"), evaluatedWith: app.collectionViews.cells)], timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "After delete button is tapped on cell, the count of cells should be 1")
    }
    
    func testRecipeCreatorInstructionView_instructionCell_isEditableAndHoldingData() {
        // Given
        let testText = "Test instruction text"
        helper.navigateToRecipeCreatorView()
        helper.tapToolTips()
        helper.enterData(recipeTitle: "TEST", recipeIngredients: "TEST", recipeInstructions: "TEST")
        helper.advanceStage(numberOfStages: 2)
        helper.tapAddInstructionButton()
        
        // When
        let textEditor = app.collectionViews.cells.containing(.staticText, identifier: "2").textViews.firstMatch
        textEditor.tap()
        waitUntilElementHasKeyboardFocus(element: textEditor, timeout: standardTimeout).typeText(testText)
        helper.tapAddInstructionButton()
        // Then
        XCTAssertEqual(textEditor.value as! String, testText, "Text in text editor should be equal to testText")
    }
    // TODO: SEE ISSUE #34 - UNTIL RESOLVED TEST BELOW WILL FAIL
    
    func test_RecipeCreatorInstructionsView_instructionCell_isUpdatingStepTextOnMove() {
        // Given
        helper.navigateToRecipeCreatorView()
        helper.tapToolTips()
        helper.enterData()
        helper.advanceStage(numberOfStages: 2)
    
        let firstCell = app.collectionViews.cells.firstMatch
        // When
        app.collectionViews.cells.element(boundBy: 3).press(forDuration: 0.5, thenDragTo: firstCell)
        // Then
        // this does not make sense really? we should already have one cell above as a header?
        let result = app.collectionViews.cells.element(boundBy: 0).staticTexts["1"].waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "On first row static text '1' should exist")
    }
 
}

