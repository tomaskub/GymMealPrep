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
    
    func bindingToStringArray(for key: Setting, at index: Int) -> Binding<String> {
        return Binding {
            return (self.settingValues[key] as? [String])?[index] ?? String()
        } set: { value in
            if var array = self.settingValues[key] as? [String], index < array.count {
                array[index] = value
                self.settingValues[key] = array
                print("successfuly set a new value of: \(value) at index: \(index)")
            }
        }
    }
    
    func appendToArray(for setting: Setting, newValue: String) {
        if var array = settingValues[setting] as? [String] {
            array.append(newValue)
            settingValues[setting] = array
        } else {
            let array = Array(repeating: String(), count: 1)
            settingValues[setting] = array
        }
    }
    
    func removeFromArray(for setting: Setting, atOffsets indexSet: IndexSet) {
        if var mutableArray = settingValues[setting] as? [Any] {
            mutableArray.remove(atOffsets: indexSet)
            settingValues[setting] = mutableArray
        }
    }
}


