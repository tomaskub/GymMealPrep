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
}
