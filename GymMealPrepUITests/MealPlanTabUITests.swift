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
}

extension MealPlanTabUITests {
    
    func navigateToMealPlanTabView() {
        app.tabBars["Tab Bar"].buttons["Meal plans"].tap()
    }
}
