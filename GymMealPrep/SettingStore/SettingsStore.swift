//
//  SettingsStore.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 27/09/2023.
//

import Foundation
import Combine

/// SettingStore is an interface allowing the app to safely access user settings defined in Setting enum from user defaults.
/// It is not supposed to be used, instead ProductionSettingStore and TestSettingStore should be used depending on use scenario. For previews use PreviewSettingStore.
///
/// SettingStore does not have defined user defaults suit and should be initialized with a named suite. In case the suite is not avaliable it will be created.
/// In case Store is initialized with nil value, standard UserDefault suite will not be used. Settings dictionary will be populated with nil values and no persistent storage will be written to.
class SettingStore: SettingStoreable {
    private var cancellables = Set<AnyCancellable>()
    
    init(userDefaults: UserDefaults?) {
        super.init()
        self.settings = createSettings(from: userDefaults)
        self.setWriteSubscribers(to: userDefaults)
    }
    
    /// Create settings dictionary based on the contents of Setting enum.
    ///
    /// If the user defaults object is nil, the funtion will return a dictionary with nil values, but all of the keys present.
    ///
    /// - Parameters:
    ///     - defaults: UserDefaults suite from which values for settings will be retrieved
    /// - Returns: Dictionary of settings and values retrieved from container
    ///
    private func createSettings(from defaults: UserDefaults?) -> [Setting : Any?] {
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
    
    /// Set up subscribers to settings dictionary and update the values in given defaults.
    /// Subscribers are stored in cancellables
    ///  - Parameter defaults: UserDefaults to which the subscribers will write updated values
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
    
    /// This function resets the store by replacing all of the setting values by default values.
    override func resetStore() {
        settings = Dictionary(uniqueKeysWithValues: Setting.allCases.map({( $0, SettingStoreable.provideDefaultValue(for: $0))}))
    }
}
