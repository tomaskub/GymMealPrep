//
//  SettingsDetailViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 04/10/2023.
//

import SwiftUI

class SettingsDetailViewModel: ObservableObject {
    
    var settingModels: [SettingModel]
    @Published private var settingStore: SettingStore
    @Published var settingValues: [Setting : Any] = .init()
    
    init(settingStore: SettingStore, settingModels: [SettingModel]) {
        self.settingStore = settingStore
        self.settingModels = settingModels
        self.settingValues = makeSettingValuesDict(settingModels: settingModels)
    }
    
    private func makeSettingValuesDict(settingModels: [SettingModel]) -> [Setting : Any] {
        var result = [Setting : Any]()
        for model in settingModels {
            result.updateValue(settingStore.settings[model.setting] as Any, forKey: model.setting)
        }
        return result
    }
    
    func binding<T>(type: T.Type, for key: Setting) -> Binding<T> where T: Initializable {
        return Binding {
            return self.settingValues[key] as? T ?? .init()
        } set: { value in
            self.settingValues[key] = value
        }
    }
}


