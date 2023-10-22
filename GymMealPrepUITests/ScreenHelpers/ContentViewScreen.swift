//
//  ContentViewScreen.swift
//  GymMealPrepUITests
//
//  Created by Tomasz Kubiak on 22/10/2023.
//

import XCTest

final class ContentViewScreen {
    private typealias Identifier = ScreenIdentifier.ContentView
    private let app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    var homeTabButton: XCUIElement {
        app.tabBars.buttons[Identifier.homeTabButton.rawValue]
    }
    
    var recipeListTabButton: XCUIElement {
        app.tabBars.buttons[Identifier.recipeListTabButton.rawValue]
    }
    
    var mealPlanTabButton: XCUIElement {
        app.tabBars.buttons[Identifier.mealPlanTabButton.rawValue]
    }
    
    var settingsTabButton: XCUIElement {
        app.tabBars.buttons[Identifier.settingsTabButton.rawValue]
    }
}
