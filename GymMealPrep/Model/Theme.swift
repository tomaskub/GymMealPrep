//
//  Theme.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 22/10/2023.
//

import Foundation

enum Theme: String, CaseIterable, SettingEnum, Initializable {
    static var defaultValue: Theme = .system
    init() {
        self = Theme.defaultValue
    }
    case light, dark, system
}
