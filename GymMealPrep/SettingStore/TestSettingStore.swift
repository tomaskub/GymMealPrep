//
//  TestSettingStore.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 01/11/2023.
//

import Foundation

class TestSettingStore: SettingStore {
    init() {
        let defaults = UserDefaults(suiteName: "test")
        super.init(userDefaults: defaults)
    }
    
    override func resetStore() {
        UserDefaults().removePersistentDomain(forName: "test")
    }
}
