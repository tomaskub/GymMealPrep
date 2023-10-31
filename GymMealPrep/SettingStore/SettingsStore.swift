//
//  SettingsStore.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 27/09/2023.
//

import Foundation
import Combine

class SettingStore: SettingStoreable {
    private var cancellables = Set<AnyCancellable>()
    private let dateFormatter = {
       let result = DateFormatter()
        result.dateFormat = "dd/MM/yyy HH:mm"
        return result
    }()

    init(userDefaults: UserDefaults?) {
        super.init()
        self.settings = createSettings(from: userDefaults)
        self.setWriteSubscribers(to: userDefaults)
    }
    
    private func createSettings(from defaults: UserDefaults?) -> [Setting: Any?] {
        guard let defaults else {
            return  Dictionary(uniqueKeysWithValues: Setting.allCases.map({( $0, nil )}))
        }
        var result: [Setting : Any?] = .init()
        for setting in Setting.allCases {
            switch setting.value {
            case .integer:
                result.updateValue(defaults.integer(forKey: setting.key), forKey: setting)
            case .double:
                result.updateValue(defaults.double(forKey: setting.key), forKey: setting)
            case .bool:
                result.updateValue(defaults.bool(forKey: setting.key), forKey: setting)
            case .string:
                result.updateValue(defaults.string(forKey: setting.key), forKey: setting)
            case .stringArray:
                result.updateValue(defaults.stringArray(forKey: setting.key), forKey: setting)
            case .date:
                if let date = defaults.object(forKey: setting.key) as? Date {
                    result.updateValue(date, forKey: setting)
                }
            case .enumeration(let enumType):
                if let value = defaults.string(forKey: setting.key) {
                    switch enumType {
                    case is Units.Type:
                        if let localResult = Units(rawValue: value) {
                            result.updateValue(localResult, forKey: setting)
                        }
                    case is Theme.Type:
                        if let localResult = Theme(rawValue: value) {
                            result.updateValue(localResult, forKey: setting)
                        }
                    default:
                        fatalError("Failed at gretting enumeration initialized for setting store dictonary")
                    }
                } else {
                    switch enumType {
                    case is Units.Type:
                            result.updateValue(Units.defaultValue, forKey: setting)
                    case is Theme.Type:
                            result.updateValue(Theme.defaultValue, forKey: setting)
                    default:
                        fatalError("Failed at gretting enumeration initialized for setting store dictonary")
                    }
                }
            case .nilValue:
                break
            }
        }
        return result
    }
    
    private func setWriteSubscribers(to defaults: UserDefaults?) {
        guard let defaults else { return }
        $settings
            .flatMap { dictionary in
                dictionary.publisher.map { (key: $0.key, value: $0.value) }
            }
            .sink { (setting, value) in
                //cases added below to avoid runtime errors
                switch setting.value {
                case .enumeration(_):
                    if let unwrappedValue = value as? (any SettingEnum),
                        let valueToSave = unwrappedValue.rawValue as? String {
                        defaults.set(valueToSave, forKey: setting.key)
                    }
                case .stringArray:
                    if let valueToSave = value as? [String] {
                        defaults.set(valueToSave, forKey: setting.key)
                    }
                case .date:
                    if let valueToSave = value as? Date {
                        defaults.set(valueToSave, forKey: setting.key)
                    }
                default:
                    defaults.set(value, forKey: setting.key)
                }
            }.store(in: &cancellables)
    }
}
