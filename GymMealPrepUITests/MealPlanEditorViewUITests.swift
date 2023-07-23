//
//  MealPlanEditorViewUITests.swift
//  GymMealPrepUITests
//
//  Created by Tomasz Kubiak on 7/20/23.
//

import XCTest

final class MealPlanEditorViewUITests: XCTestCase {
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
    
    func test_mealPlanEditorView_sectionHeaders_exist() {
        // Given
        navigateToEdit()
        // Then
        let collectionsQuery = app.collectionViews
        let summaryStaticText = collectionsQuery.staticTexts["SUMMARY"]
        let firstMealStaticText = collectionsQuery.staticTexts["Meal #1"]
        let secondMealStaticText = collectionsQuery.staticTexts["Meal #2"]
        let thirdMealStaticText = collectionsQuery.staticTexts["Meal #3"]
        let existancePredicate = NSPredicate(format: "exists == true")
        let expectations = [
            expectation(for: existancePredicate, evaluatedWith: summaryStaticText),
            expectation(for: existancePredicate, evaluatedWith: firstMealStaticText),
            expectation(for: existancePredicate, evaluatedWith: secondMealStaticText),
            expectation(for: existancePredicate, evaluatedWith: thirdMealStaticText)
        ]
        let result = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "The headers static texts should exist")
    }
    
    func test_mealPlanEditorView_mealRecipesAndIngredientsText_exists() {
        // Given
        navigateToEdit()
        // TODO: Remove with type safe and change safe reference
        let elementsQuery = app.collectionViews.staticTexts
        
        let slowCookerStaticText = elementsQuery["Slow cooker chicken tikka masala"]
        let riceStaticText = elementsQuery["Rice 50.0 grams"]
        let porkShoulderStaticText = elementsQuery["Pork shoulder 200.0 grams"]
        let potatoesStaticText = elementsQuery["Potatoes 250.0 gram"]
        let coleslawStaticText = elementsQuery["Coleslaw 100.0 grams"]
        let potatoHashStaticText = elementsQuery["Breakfast potato hash"]

        
        // Then
        
        let existancePredicate = NSPredicate(format: "exists == true")
        
        let potatoHashExpectation = expectation(for: existancePredicate, evaluatedWith: potatoHashStaticText)
        let slowCookerExpectation = expectation(for: existancePredicate, evaluatedWith: slowCookerStaticText)
        let riceExpectation = expectation(for: existancePredicate, evaluatedWith: riceStaticText)
        
        let porkShoulderExpectation = expectation(for: existancePredicate, evaluatedWith: porkShoulderStaticText)
        let potatoesExpectation = expectation(for: existancePredicate, evaluatedWith: potatoesStaticText)
        let coleslawExpectation = expectation(for: existancePredicate, evaluatedWith: coleslawStaticText)
        
        let firstResult = XCTWaiter.wait(for: [potatoHashExpectation, slowCookerExpectation, riceExpectation], timeout: standardTimeout)
        XCTAssertEqual(firstResult, .completed, "Potato hash, slow cooker and rice static texts should exist")
        
        app.swipeUp()
        
        let resultSecond = XCTWaiter.wait(for: [porkShoulderExpectation, potatoesExpectation, coleslawExpectation], timeout: standardTimeout)
        XCTAssertEqual(resultSecond, .completed, "Pork, potatoes and coleslaw static texts should exist")
    }
    
    func test_mealPlanEditorView_addToMealButton_shouldShowAddingSheet() {
        // Given
        navigateToEdit()
        let addToMealButton = app.collectionViews.staticTexts["Add to meal"].firstMatch
        let typeToggle = app.sheets.toggles["Adding ingredient"]
        
        // When
        addToMealButton.tap()
        
        // Then
        let result = typeToggle.waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "Toggle switch with adding ingredient should exist")
    }
    
    func test_mealPlanEditorView_RecipeRowSwipeLeft_shouldDisplayDeleteIcon() {
        // Given
        navigateToEdit()
        let recipeRow = app.collectionViews.cells.staticTexts["Breakfast potato hash"]
        let deleteButton = app.collectionViews.buttons["Delete"]
        // When
        recipeRow.swipeLeft()
        
        // Then
        let result = deleteButton.waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "Delete button should exist")
    }
    
    func test_mealPlanEditorView_IngredientRowSwipeLeft_shouldDisplayDeleteIcon() {
        // Given
        navigateToEdit()
        let ingredientRow = app.collectionViews.cells.staticTexts["Rice 50.0 grams"]
        let deleteButton = app.collectionViews.buttons["Delete"]
        
        // When
        ingredientRow.swipeLeft()
        
        // Then
        let result = deleteButton.waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "Delete button should exist")
    }
    
    func navigateToEdit() {
        app.tabBars["Tab Bar"].buttons["Meal plans"].tap()
        app.collectionViews.cells.buttons["Sample Test Plan, Total of 3 meals, Calories, 1845, Proteins, 103, Fats, 88, Carbs, 156"].tap()
        app.navigationBars.buttons["Edit"].tap()
    }
}
