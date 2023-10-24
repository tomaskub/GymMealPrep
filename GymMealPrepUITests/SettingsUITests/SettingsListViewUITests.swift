//
//  SettingsListViewUITests.swift
//  GymMealPrepUITests
//
//  Created by Tomasz Kubiak on 22/10/2023.
//

import XCTest

final class SettingsListViewUITests: XCTestCase {

    private var app: XCUIApplication!
    
    private var contentScreen: ContentViewScreen {
        ContentViewScreen(app: app)
    }
    
    private var helper: SettingsUITestsHelper!
    
    override func setUp() {
        super.setUp()
        app = .init()
        helper = SettingsUITestsHelper(app: app)
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        app = nil
    }
    
    func test_NavigatingToSettingsView() {
        // Given
        let predicate = NSPredicate(format: "exists == true")
        let navTitle = app.navigationBars.staticTexts["Settings"]
        let expectation = expectation(for: predicate, evaluatedWith: navTitle)
        // When
        helper.navigateToSettingsTabView()
        // Then
        let result = XCTWaiter.wait(for: [expectation], timeout: 2.5)
        XCTAssertEqual(result, .completed, "Navigation title 'Settings' should exist")
    }
    
    func test_navigatingToCalorieTargetDetailView() {
        // Given
        let existsPredicate = NSPredicate(format: "exists == true")
        let caloriesCell = app.cells.staticTexts["Target calories"]
        let detailNavTitleText = app.navigationBars.staticTexts["Target calories"]
        let detailInputTextField = app.cells.textFields.firstMatch
        let expectations = [
            expectation(for: existsPredicate, evaluatedWith: detailNavTitleText),
            expectation(for: NSPredicate(format: "count == 1"), evaluatedWith: app.cells),
            expectation(for: existsPredicate, evaluatedWith: detailInputTextField)
        ]
        helper.navigateToSettingsTabView()
        // When
        caloriesCell.tap()
        // Then
        let result = XCTWaiter.wait(for: expectations, timeout: 5)
        XCTAssertEqual(result, .completed, "The expectations should be met")
    }
}
