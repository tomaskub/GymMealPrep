//
//  SettingsUITestsHelper.swift
//  GymMealPrepUITests
//
//  Created by Tomasz Kubiak on 23/10/2023.
//

import XCTest
/// This is a class that can handle the interactions with Settings views
final class SettingsUITestsHelper {
    
    private var app: XCUIApplication!
    
    private var contentScreen: ContentViewScreen {
        ContentViewScreen(app: app)
    }
    
    init(app: XCUIApplication!) {
        self.app = app
    }
    
    
    func navigateToSettingsTabView() {
        contentScreen.settingsTabButton.tap()
    }
}
