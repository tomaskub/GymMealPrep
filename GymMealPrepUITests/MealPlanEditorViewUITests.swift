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
    
    func navigateToEdit() {
        app.tabBars["Tab Bar"].buttons["Meal plans"].tap()
        app.collectionViews.cells.buttons["Sample Test Plan, Total of 3 meals, Calories, 1845, Proteins, 103, Fats, 88, Carbs, 156"].tap()
        app.navigationBars.buttons["Edit"].tap()
    }
}
