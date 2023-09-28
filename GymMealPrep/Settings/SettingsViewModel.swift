//
//  SettingsViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 26/08/2023.
//

import Foundation

struct SettingModel: Identifiable {
    var id: UUID = .init()
    var setting: SettingStore.Setting
    var value: Int
}

class SettingsViewModel: ObservableObject {
    @Published private var settingStore: SettingStore = .init()
    
    var setingsArray: [SettingModel]
    
    init() {
        self.setingsArray = .init()
        self.setingsArray = [
            SettingModel(setting: .calorieTarget, value: settingStore.calorieTarget),
            SettingModel(setting: .macroTargetProtein, value: settingStore.proteinTarget)
        ]
    }
}
