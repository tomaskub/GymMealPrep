//
//  RecipeCreatorConfirmationViewUITests.swift
//  GymMealPrepUITests
//
//  Created by Tomasz Kubiak on 7/27/23.
//

import XCTest

final class RecipeCreatorConfirmationViewUITests: XCTestCase {
    //MARK: INFORMATION ABOUT NAMING
    /*
     Naming structure: test_UnitOfWork_StateUnderTest_ExpectedBehaviour
     Naming structure: test_[Struct or class]_[UI component]_[expected result]
     Testing structure: Given, When, Then
     */
    var app: XCUIApplication!
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
    
    func test_RecipeCreatorConfirmationView_UIElements_exist() {
        // Given
        navigateToRecipeCreatorConfirmationView()
        
        let navigationTitle = app.navigationBars.staticTexts["Add details"]
        let photoSectionHeader = app.collectionViews.staticTexts["PHOTO"]
        let timeCookingSectionHeader = app.collectionViews.staticTexts["TIME COOKING"]
        let tagsSectionHeader = app.collectionViews.staticTexts["TAGS"]
        
        let cookingTimeStaticText = app.collectionViews.staticTexts["Cooking time:"]
        let preparingTimeStaticText = app.collectionViews.staticTexts["Preparing time:"]
        let waitingTimeStaticText = app.collectionViews.staticTexts["Time waiting:"]
        
        let cookingTimeTextField = app.collectionViews.textFields["cooking-time-text-field"]
        let preparingTimeTextField = app.collectionViews.textFields["preparing-time-text-field"]
        let waitingTimeTextField = app.collectionViews.textFields["waiting-time-text-field"]
        
        let addPhotoButton = app.collectionViews.buttons["add-change-photo"]
        let addTagButton = app.collectionViews.buttons["Add"]
        let tagTextField = app.collectionViews.cells.containing(.button, identifier: "Add").textFields["Add new tag"]
        
        // Then
        let predicate = NSPredicate(format: "exists == true")
        var expectations = [XCTestExpectation]()
        for element in [navigationTitle, photoSectionHeader, timeCookingSectionHeader, tagsSectionHeader, cookingTimeStaticText, preparingTimeStaticText, waitingTimeStaticText, cookingTimeTextField, preparingTimeTextField, waitingTimeTextField, addPhotoButton, addTagButton, tagTextField] {
            expectations.append(expectation(for: predicate, evaluatedWith: element))
        }
        let result = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "All elements should exist")
    }
    
    func test_RecipeCreatorConfirmationView_AddButton_addsTagFromTextOnTap() {
        // Given
        navigateToRecipeCreatorConfirmationView()
        let testInput = "Test tag"
        // When
        addTag(withText: testInput)
        // Then
        let result = app.collectionViews.staticTexts[testInput].waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "Static text 'Test tag' should exist")
    }
    
    func test_RecipeCreatorConfirmationView_AddButton_doesNotAddTag_whenTextFieldIsEmpty() {
        // Given
        navigateToRecipeCreatorConfirmationView()
        let testInput = ""
        // When
        addTag(withText: testInput)
        // Then
        //TODO: DEF NEEDS TO BE REWORKED
        let result = app.collectionViews.children(matching: .cell).element(boundBy: 5).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .staticText).element.waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "Static text 'Test tag' should exist")
    }
    
    func test_RecipeCreatorConfirmationView_Tag_XButtonExistsAfterLongPress(){
        // Given
        let testInput = "Test tag"
        navigateToRecipeCreatorConfirmationView()
        addTag(withText: testInput)
        // When
        app.collectionViews.staticTexts[testInput].press(forDuration: 1)
        // Then
        let result = app.collectionViews.buttons["x.circle"].waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "Delete tag button should exist")
    }
    
    func test_RecipeCreatorConfirmationView_Tag_isRemovedAfterXButtonTap(){
        // Given
        let testInput = "Test tag"
        navigateToRecipeCreatorConfirmationView()
        addTag(withText: testInput)
        let tag = app.collectionViews.staticTexts[testInput]
        tag.press(forDuration: 1)
        // When
        app.collectionViews.buttons["x.circle"].tap()
        // Then
        let result = tag.waitForNonExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "'Test tag' static test should not exist")
    }
    // Confirm photo part works
    func test_RecipeCreatorConfirmationView_AddPhotoButton_displaysPhotoPicker() {
        // Given
        navigateToRecipeCreatorConfirmationView()
        let addPhotoButton = app.collectionViews.buttons["add-change-photo"]
        // When
        addPhotoButton.tap()
        // Then
        let result = app.sheets.firstMatch.waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "A sheet should exists after tap")
    }
    
    // Confirm text fields work
    func test_RecipeCreatorConfirmationView_TimeTextFields_areEditable() {
        // Given
        navigateToRecipeCreatorConfirmationView()
        let cookingTimeTextField = app.collectionViews.textFields["cooking-time-text-field"]
        let preparingTimeTextField = app.collectionViews.textFields["preparing-time-text-field"]
        let waitingTimeTextField = app.collectionViews.textFields["waiting-time-text-field"]
        // When
        cookingTimeTextField.tap()
        waitUtilElementHasKeyboardFocus(element: cookingTimeTextField, timeout: standardTimeout).typeText("15")
        preparingTimeTextField.tap()
        waitUtilElementHasKeyboardFocus(element: preparingTimeTextField, timeout: standardTimeout).typeText("25")
        waitingTimeTextField.tap()
        waitUtilElementHasKeyboardFocus(element: waitingTimeTextField, timeout: standardTimeout).typeText("35")
        // Then
        let expectations = [
        expectation(for: NSPredicate(format: "value == '15'"), evaluatedWith: cookingTimeTextField),
        expectation(for: NSPredicate(format: "value == '25'"), evaluatedWith: preparingTimeTextField),
        expectation(for: NSPredicate(format: "value == '35'"), evaluatedWith: waitingTimeTextField)]
        
        let result = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "The field values should match the typed in values")
    }
    
}

extension RecipeCreatorConfirmationViewUITests {
    
    func navigateToRecipeCreatorConfirmationView() {
        app.tabBars["Tab Bar"].buttons["Recipes"].tap()
        let recipiesNavigationBar = app.navigationBars["Recipes"]
        recipiesNavigationBar.images["Back"].tap()
        _ = recipiesNavigationBar.buttons["Add from text"].waitForExistence(timeout: 1)
        recipiesNavigationBar.buttons["Add from text"].tap()
        app.staticTexts["advance-stage-button"].tap()
        app.staticTexts["advance-stage-button"].tap()
        app.staticTexts["advance-stage-button"].tap()
    }
    
    func addTag(withText text: String) {
        let inputTextField = app.collectionViews.cells.containing(.button, identifier: "Add").textFields["Add new tag"]
        inputTextField.tap()
        waitUtilElementHasKeyboardFocus(element: inputTextField, timeout: standardTimeout).typeText(text)
        app.collectionViews.buttons["Add"].tap()
    }
}
