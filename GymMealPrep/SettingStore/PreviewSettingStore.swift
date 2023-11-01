//
//  PreviewSettingStore.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 31/10/2023.
//

import Foundation

class PreviewSettingStore: SettingStoreable {
    override init() {
        super.init()
        self.settings = {
            var result: [Setting : Any?] = .init()
            for setting in Setting.allCases {
                result.updateValue(SettingStoreable.provideDefaultValue(for: setting), forKey: setting)
            }
            return result
        }()
    }
}
