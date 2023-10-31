//
//  PreviewSettingStore.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 31/10/2023.
//

import Foundation

class PreviewSettingStore: SettingStoreable {
    override init() {
        super.init()
        self.settings = {
            var result: [Setting : Any?] = .init()
            for setting in Setting.allCases {
                result.updateValue(returnDefaultValue(for: setting), forKey: setting)
            }
            return result
        }()
    }
    
    private func returnDefaultValue(for setting: Setting) -> Any? {
        switch setting {
        case .calorieTarget:
            return Double(3100)
        case .macroTargetProtein:
            return Double(180)
        case .macroTargetFat:
            return Double(60)
        case .macroTargetCarb:
            return Double(120)
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
