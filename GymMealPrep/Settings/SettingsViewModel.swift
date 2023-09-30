//
//  SettingsViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 26/08/2023.
//

import Foundation

struct SettingGroup: Identifiable {
    let id: UUID = .init()
    var settings: [SettingModel]
}

enum SettingValue {
    case bool(Bool)
    case int(Int)
}
struct SettingModel: Identifiable {
    let id: UUID = .init()
    var setting: SettingStore.Setting
    var value: SettingValue
}

class SettingsViewModel: ObservableObject {
    @Published private var settingStore: SettingStore = .init()
    
    var setingsArray: [SettingModel]
    
    init() {
        self.setingsArray = .init()
        self.setingsArray = [
            SettingModel(setting: .calorieTarget, value: .int(settingStore.calorieTarget)),
            SettingModel(setting: .macroTargetProtein, value: .int(settingStore.proteinTarget)),
            SettingModel(setting: .useImperial, value: .bool(settingStore.useImperial))
        ]
    }
}
