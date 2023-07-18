//
//  MealPlanTabUITests.swift
//  GymMealPrepUITests
//
//  Created by Tomasz Kubiak on 7/18/23.
//

import XCTest

final class MealPlanTabUITests: XCTestCase {

    
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
    
    func test_MealPlanTab_TabBar_shouldNavigateToTab() {
        // When
        navigateToMealPlanTabView()
        // Then
        let mealPlansTitle = app.navigationBars["Meal plans"].staticTexts["Meal plans"]
        let result = mealPlansTitle.waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "Meal plan navigation title should exist")
    }
    
    func test_MealPlanTab_NavigationButtons_shouldExist() {
        // When
        navigateToMealPlanTabView()
        
        // Then
        let navigationBar = app.navigationBars["Meal plans"]
        let addButton = navigationBar.buttons["Add"]
        let moreButton = navigationBar.buttons["More"]
        
        let expectations = [
            expectation(for: NSPredicate(format: "exists == true"), evaluatedWith: addButton),
            expectation(for: NSPredicate(format: "exists == true"), evaluatedWith: moreButton)]
        
        let result = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "Add button and more button should exist")
    }
    
    func test_MealPlanTab_AddButton_shouldNavigateMealPlanHostViewEditing() {
        // Given
        navigateToMealPlanTabView()
        
        // When
        app.navigationBars["Meal plans"].buttons["Add"].tap()
        
        // Then
        let navBar = app.navigationBars["Adding new meal plan"]
        let navigationBarTitle = navBar.staticTexts["Adding new meal plan"]
        let doneButton = navBar.buttons["Done"]
        
        let expectations = [
            expectation(for: NSPredicate(format: "exists == true"), evaluatedWith: doneButton),
            expectation(for: NSPredicate(format: "exists == true"), evaluatedWith: navigationBarTitle)]
        
        let result = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "Navigation bar title should exist and done button should exist")
    }
    
    func test_MealPlanTab_ListRowSwipe_shouldShowSwipeActions() {
        // Given
        navigateToMealPlanTabView()
        
        // When
        app.collectionViews.cells.buttons["Sample Test Plan, Total of 3 meals, Calories, 1845, Proteins, 103, Fats, 88, Carbs, 156"].swipeLeft()
        
        //Then
        let editButton = app.collectionViews.buttons["Edit"]
        let deleteButton = app.collectionViews.buttons["Delete"]
        let expectations = [
            expectation(for: NSPredicate(format: "exists == true"), evaluatedWith: editButton),
            expectation(for: NSPredicate(format: "exists == true"), evaluatedWith: deleteButton)]
        
        let result = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "Edit and delete buttons should exist on swipe left")
    }
    
    func test_MealPlanTab_ListRowSwipeAndEdit_shouldNavigateToMealPlanEditorView() {
        // Given
        navigateToMealPlanTabView()
        app.collectionViews.cells.buttons["Sample Test Plan, Total of 3 meals, Calories, 1845, Proteins, 103, Fats, 88, Carbs, 156"].swipeLeft()
        let editButton = app.collectionViews.buttons["Edit"]
        
        // When
        editButton.tap()
        
        // Then
        let navBar = app.navigationBars["Editing meal plan"]
        let navigationBarTitle = navBar.staticTexts["Editing meal plan"]
        let doneButton = navBar.buttons["Done"]
        let textField = app.textFields["Sample Test Plan"]
        let expectations = [
            expectation(for: NSPredicate(format: "exists == true"), evaluatedWith: doneButton),
            expectation(for: NSPredicate(format: "exists == true"), evaluatedWith: navigationBarTitle),
            expectation(for: NSPredicate(format: "exists == true"), evaluatedWith: textField)]
        
        let result = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "Navigation bar title with Sample Test Plan text should exist and done button should exist, text field containg meal plan name should exist")
    }
    
    func test_MealPlanTab_ListRowSwipeAndDelete_shouldDeleteMealPlan() {
        //Given
        navigateToMealPlanTabView()
        let mealPlanCell = app.collectionViews.cells.buttons["Sample Test Plan, Total of 3 meals, Calories, 1845, Proteins, 103, Fats, 88, Carbs, 156"]
        let deleteButton = app.collectionViews.buttons["Delete"]
        
        // When
        mealPlanCell.swipeLeft()
        deleteButton.tap()
        
        // Then
        let expectation = expectation(for: NSPredicate(format: "exists == false"), evaluatedWith: mealPlanCell)
        let result = XCTWaiter.wait(for: [expectation], timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "Sample Test Plan list row should not exist")
    }
}

extension MealPlanTabUITests {
    
    func navigateToMealPlanTabView() {
        app.tabBars["Tab Bar"].buttons["Meal plans"].tap()
    }
}
