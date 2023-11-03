//
//  ProductionSettingStore.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 01/11/2023.
//

import Foundation

/// ProductionSettingStore is an interface allowing the app to safely access user settings defined in Setting enum from user defaults.
///
/// Production store should be used to manage and read values that user 
class ProductionSettingStore: SettingStore {
    private static let suiteName: String = "GymMealPrep"
    init() {
        let defaults = UserDefaults(suiteName: ProductionSettingStore.suiteName)
        super.init(userDefaults: defaults)
    }
}
