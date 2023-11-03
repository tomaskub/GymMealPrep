//
//  TestSettingStore.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 01/11/2023.
//

import Foundation

/// TestSettingStore is an interface allowing the app to safely access user settings defined in Setting enum from user defaults.
///
/// TestSettingStore has a seperate UserDefaults suite with name 'test'. This suite should be used for testing the application, in unit test, integration test and UI test. Setup for UI test should modify settings property and not the user defaults in suite directly
class TestSettingStore: SettingStore {
    private static let suiteName: String = "test"
    init() {
        let defaults = UserDefaults(suiteName: TestSettingStore.suiteName)
        super.init(userDefaults: defaults)
    }
}
