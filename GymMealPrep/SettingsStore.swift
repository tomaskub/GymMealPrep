//
//  SettingsStore.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 27/09/2023.
//

import Foundation
import Combine

class SettingStore: ObservableObject {
    
    private let dateFormatter = {
       let result = DateFormatter()
        result.dateFormat = "dd/MM/yyy HH:mm"
        return result
    }()
    private let defaults = UserDefaults.standard
    private var subscriptions = Set<AnyCancellable>()

    @Published var settings: [Setting : Any?]
    
    init() {
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
                        }
                    case is Theme.Type:
                        if let result = Theme(rawValue: value) {
                            settings.updateValue(result, forKey: setting)
                        }
                    default:
                        fatalError("Failed at gretting enumeration initialized for setting store dictonary")
                    }
                } else {
                    switch enumType {
                    case is Units.Type:
                            settings.updateValue(Units.defaultValue, forKey: setting)
                    case is Theme.Type:
                            settings.updateValue(Theme.defaultValue, forKey: setting)
                    default:
                        fatalError("Failed at gretting enumeration initialized for setting store dictonary")
                    }
                }
            case .nilValue:
                break
            }
            
        }
    }
}
extension SettingStore {
    private func updateSetting(for setting: Setting, with value: Any?) {
        defaults.set(value, forKey: setting.key)
    }
}
