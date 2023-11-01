//
//  ProductionSettingStore.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 01/11/2023.
//

import Foundation
class ProductionSettingStore: SettingStore {
    init() {
        let defaults = UserDefaults.standard
        super.init(userDefaults: defaults)
    }
}
