//
//  SettingsStore.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 27/09/2023.
//

import Foundation
import Combine

class SettingStore: ObservableObject {
    
    let dateFormatter = {
       let result = DateFormatter()
        result.dateFormat = "dd/MM/yyy HH:mm"
        return result
    }()
    private let defaults = UserDefaults.standard
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var calorieTarget: Int
    @Published var proteinTarget: Int
    @Published var fatTarget: Int
    @Published var carbTarget: Int
    @Published var units: String
    
    @Published var settings: [Setting : Any?]
    
    init() {
        self.calorieTarget = defaults.integer(forKey: Setting.calorieTarget.key)
        self.proteinTarget = defaults.integer(forKey: Setting.macroTargetProtein.key)
        self.fatTarget = defaults.integer(forKey: Setting.macroTargetFat.key)
        self.carbTarget = defaults.integer(forKey: Setting.macroTargetCarb.key)
        self.units = defaults.string(forKey: Setting.units.key) ?? "metric"
        
        self.settings = .init()
        for setting in Setting.allCases {
            switch setting.value {
            case .integer:
                settings.updateValue(defaults.integer(forKey: setting.key), forKey: setting)
            case .bool:
                settings.updateValue(defaults.bool(forKey: setting.key), forKey: setting)
            case .string:
                settings.updateValue(defaults.string(forKey: setting.key), forKey: setting)
            case .stringArray:
                settings.updateValue(defaults.stringArray(forKey: setting.key), forKey: setting)
            case .date:
                if let date = defaults.object(forKey: setting.key) as? Date {
                    settings.updateValue(date, forKey: setting)
                }
            case .enumeration(let enumType):
                if let value = defaults.string(forKey: setting.key) {
                    switch enumType {
                    case is Units.Type:
                        if let result = Units(rawValue: value) {
                            settings.updateValue(result, forKey: setting)
                        } else {
                            settings.updateValue(Units.defaultValue, forKey: setting)
                        }
                    case is Theme.Type:
                        if let result = Theme(rawValue: value) {
                            settings.updateValue(result, forKey: setting)
                        } else {
                            settings.updateValue(Theme.defaultValue, forKey: setting)
                        }
                    default:
                        fatalError("Failed at gretting enumeration initialized for setting store dictonary")
                    }
                }
            case .nilValue:
                break
            }
            
        }
        self.setUpWriteSubscribers()
    }
}
extension SettingStore {
    private func setUpWriteSubscribers() {
        
        $calorieTarget.sink { [weak self] calories in
            self?.updateSetting(for: .calorieTarget, with: calories)
        }.store(in: &subscriptions)
        
        $proteinTarget.sink { [weak self] proteins in
            self?.updateSetting(for: .macroTargetProtein, with: proteins)
        }.store(in: &subscriptions)
        
        $fatTarget.sink { [weak self] fats in
            self?.updateSetting(for: .macroTargetFat, with: fats)
        }.store(in: &subscriptions)
        
        $carbTarget.sink { [weak self] carbs in
            self?.updateSetting(for: .macroTargetCarb, with: carbs)
        }.store(in: &subscriptions)
    }
    private func updateSetting(for setting: Setting, with value: Any?) {
        defaults.set(value, forKey: setting.key)
    }
}
