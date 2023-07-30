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
        
        let cookingTimeTextField = app.collectionViews.cells.containing(.staticText, identifier: "Cooking time:").textFields["minutes"]
        let preparingTimeTextField = app.collectionViews.cells.containing(.staticText, identifier: "Preparing time:").textFields["minutes"]
        let waitingTimeTextField = app.collectionViews.cells.containing(.staticText, identifier: "Time waiting:").textFields["minutes"]
        
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
    // Confirm text fields work
    
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
