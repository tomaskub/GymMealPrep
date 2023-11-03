//
//  SettingStoreable.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 31/10/2023.
//

import Foundation

/// Protocol like class describing features avaliable in all of the stores
///
///  This class provides one property containing settings as a dictionary with Setting as a key values and any? as values. It also provides function to reset the store and a static func to provide default value for all of the settings
///  Concrete implementations of setting store need to override resetStore and add logic to populate and update the settings dictionary.
class SettingStoreable: ObservableObject {
    @Published var settings: [Setting : Any?] = .init()
    
    
    /// This function resets the store by removing all of the key value pairs from the underlying storage and settings dictionary. The settings in the storage and dictionary will be replaced by default values.
    ///
    /// This method needs to be overriden by inheriting concrete implementations of setting storage. 
    func resetStore() {
        
    }
}

extension SettingStoreable {
    static func provideDefaultValue(for setting: Setting) -> Any? {
        switch setting {
        case .calorieTarget:
            return Double(3100)
        case .macroTargetProtein:
            return Double(40)
        case .macroTargetFat:
            return Double(30)
        case .macroTargetCarb:
            return Double(30)
        case .numberOfMeals:
            return Int(4)
        case .mealNames:
            return ["Breakfast", "Lunch", "Dinner", "Supper"]
        case .groceries:
            return Calendar.current.date(byAdding: .day, value: 3, to: Date())
        case .nextPlan:
            return Calendar.current.date(byAdding: .day, value: 10, to: Date())
        case .units:
            return Units.metric
        case .theme:
             return Theme.light
        case .rateApp, .contactUs, .terms, .privacy, .apiReference:
            return nil
        }
    }
}
