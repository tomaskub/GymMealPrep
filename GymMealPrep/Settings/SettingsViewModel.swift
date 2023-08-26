//
//  SettingsViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 26/08/2023.
//

import Foundation

class SettingsViewModel: ObservableObject {
    var setingsArray = [
        K.SettingKeys.theme,
        K.SettingKeys.calorieTarget
    ]
}
