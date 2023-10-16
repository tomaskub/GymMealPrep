//
//  SettingsDetailViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 04/10/2023.
//

import SwiftUI
import Combine

class SettingsDetailViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = .init()
    var settingModels: [SettingModel]
    
    @Published private var settingStore: SettingStore
    @Published var settingValues: [Setting : Any] = .init()
    
    init(settingStore: SettingStore, settingModels: [SettingModel]) {
        self.settingStore = settingStore
        self.settingModels = settingModels
        self.settingValues = setSettingValuesDict(settingModels: settingModels)
        setSettingValuesSubscriber()
    }
    
    private func setSettingValuesSubscriber() {
        $settingValues
            .sink { dictionary in
                dictionary.forEach { (key, value) in
                    // this causes runtime error when saving array if it not casted to [String] before saving
                    if key.value != .stringArray {
                        self.settingStore.settings.updateValue(value, forKey: key)
                    } else {
                        if let _value = value as? [String] {
                            self.settingStore.settings.updateValue(_value, forKey: key)
                        }
                    }
                }
            }.store(in: &cancellables)
    }
    
    private func setSettingValuesDict(settingModels: [SettingModel]) -> [Setting : Any] {
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
    
    func bindingArray<T>(type: T.Type, for key: Setting, at index: Int) -> Binding<T> where T: Initializable {
        return Binding {
            return (self.settingValues[key] as? [T])?[index] ?? .init()
        } set: { value in
            if var array = self.settingValues[key] as? [T], index < array.count {
                array[index] = value
                self.settingValues[key] = array
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


