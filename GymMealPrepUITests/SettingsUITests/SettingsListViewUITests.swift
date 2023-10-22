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
    
    override func setUp() {
        super.setUp()
        app = .init()
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
        contentScreen.settingsTabButton.tap()
        // Then
        let result = XCTWaiter.wait(for: [expectation], timeout: 2.5)
        XCTAssertEqual(result, .completed, "Navigation title 'Settings' should exist")
    }
}
