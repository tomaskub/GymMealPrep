//
//  RecipeCreatorUITestsHelper.swift
//  GymMealPrepUITests
//
//  Created by Tomasz Kubiak on 8/4/23.
//

import XCTest
/// This is a class that can handle the interactions with RecipeCreator views
final class RecipeCreatorUITestsHelper {
    
    var app: XCUIApplication!
    
    init(forApplication: XCUIApplication!) {
        self.app = forApplication
    }
    
    func navigateToRecipeCreatorView() {
        app.tabBars["Tab Bar"].buttons["Recipes"].tap()
        let recipiesNavigationBar = app.navigationBars["Recipes"]
        recipiesNavigationBar.images["Back"].tap()
        _ = recipiesNavigationBar.buttons["Add from text"].waitForExistence(timeout: 1)
        recipiesNavigationBar.buttons["Add from text"].tap()
    }
    
    func advanceStage(numberOfStages i: Int = 1) {
        for _ in 0..<i {
            app.staticTexts["advance-stage-button"].tap()
        }
    }
    
    func goToLastStage() {
        app.images["back-button"].tap()
    }
    
    func goToNextStage() {
        app.images["next-button"].tap()
    }
}
