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
    
    // Confirm all of the elements exist on showing the screen
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
    
    // Confirm adding tags works
    // Confirm removing tags work
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
}
