//
//  MealPlanHostViewUITests.swift
//  GymMealPrepUITests
//
//  Created by Tomasz Kubiak on 7/19/23.
//

import XCTest

final class MealPlanHostViewUITests: XCTestCase {
    
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
    
    func test_MealPlanHostView_isDisplayingCorrectTitle() {
        // Given
        let navTitle = app.navigationBars["Sample Test Plan"].staticTexts["Sample Test Plan"]
        navigateToMealPlanDetail()
        
        // Then
        let navTitleExistance = navTitle.waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(navTitleExistance, "Navigation title for Sample Test Plan should exist")
    }
    
    func test_MealPlanHostView_EditButton_isExisting() {
        // Given
        navigateToMealPlanDetail()
        let editButton = app.navigationBars["Sample Test Plan"].buttons["Edit"]
        
        // Then
        let editButtonExistance = editButton.waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(editButtonExistance, "Edit button should exist")
    }
    
    func test_MealPlanHostView_EditButton_isStartingEditModeOnTap() {
        // Given
        navigateToMealPlanDetail()
        let editButton = app.navigationBars["Sample Test Plan"].buttons["Edit"]
        
        // When
        editButton.tap()
        
        // Then
        let navTitleText = app.navigationBars.staticTexts["Editing meal plan"]
        let navTitleTextExistance = navTitleText.waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(navTitleTextExistance, "Editing meal plan navigation title should exist")
    }
    
    func test_MealPlanHostView_EditingButton_isChangingToDoneButtonOnTap() {
        // Given
        navigateToMealPlanDetail()
        
        // When
        app.navigationBars["Sample Test Plan"].buttons["Edit"].tap()
        
        // Then
        let doneButtonExistance = app.navigationBars["Editing meal plan"].buttons["Done"].waitForExistence(timeout: standardTimeout)
        XCTAssert(doneButtonExistance, "Done button should exist when editing meal plan")
    }
    
    func test_MealPlanHostView_DetailView_isUpdatingMealsAfterEdit() {
        // Given
        navigateToMealPlanEditor()
        let deleteMealButton = app.collectionViews.buttons["Delete meal"].firstMatch
        let doneButton = app.navigationBars.buttons["Done"]
        let meal1RecipeStaticText = app.collectionViews.cells.staticTexts["Breakfast potato hash"]
        
        // When
        deleteMealButton.tap()
        doneButton.tap()
        
        // Then
        let result = meal1RecipeStaticText.waitForNonExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "Text 'Breakfast potato hash' should not exist")
    }
}

extension MealPlanHostViewUITests {
    
    func navigateToMealPlanTabView() {
        app.tabBars["Tab Bar"].buttons["Meal plans"].tap()
    }
    
    func navigateToMealPlanDetail() {
        navigateToMealPlanTabView()
        app.collectionViews.cells.buttons["Sample Test Plan, Total of 3 meals, Calories, 1845, Proteins, 103, Fats, 88, Carbs, 156"].tap()
    }
    
    func navigateToMealPlanEditor() {
        navigateToMealPlanDetail()
        app.navigationBars.buttons["Edit"].tap()
    }
}
