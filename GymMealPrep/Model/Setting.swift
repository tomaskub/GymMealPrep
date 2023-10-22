//
//  Setting.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 30/09/2023.
//

import Foundation

enum Units: String, SettingEnum, Initializable {
    static var defaultValue: Units = .metric
    
    case metric, imperial
    init() {
        self = Units.defaultValue
    }
}

enum Theme: String, CaseIterable, SettingEnum, Initializable {
    static var defaultValue: Theme = .system
    init() {
        self = Theme.defaultValue
    }
    case light, dark, system
}


enum Setting: String, CaseIterable, Hashable {
    case calorieTarget
    case macroTargetProtein
    case macroTargetFat
    case macroTargetCarb
    case numberOfMeals
    case mealNames
    case groceries // date for groceries (next date)
    case nextPlan // day of week where next plan starts
    case units // metric or imperial
    case theme
    case rateApp
    case contactUs
    case terms
    case privacy
    case apiReference
    
    var label: String {
        switch self {
        case .calorieTarget:
            return "Target calories"
        case .macroTargetProtein:
            return "Target protein intake"
        case .macroTargetFat:
            return "Target fat intake"
        case .macroTargetCarb:
            return "Target carb intake"
        case .theme:
            return "Color theme"
        case .units:
            return "Units"
        case .groceries:
            return "Groceries"
        case .nextPlan:
            return "Next plan"
        case .numberOfMeals:
            return "Number of meals"
        case .mealNames:
            return "Meal names"
        case .apiReference:
            return "API information"
        case .privacy:
            return "Privacy information"
        case .terms:
            return "Terms information"
        case .contactUs:
            return "Contact Us"
        case .rateApp:
            return "Rate Us!"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .calorieTarget:
            return "target"
        case .macroTargetProtein:
            return "target"
        case .macroTargetFat:
            return "target"
        case .macroTargetCarb:
            return "target"
        case .groceries:
            return "bag"
        case .nextPlan:
            return "calendar"
        case .units:
            return "ruler"
        case .theme:
            return "circle.lefthalf.filled"
        case .rateApp:
            return "star.fill"
        case .contactUs:
            return "phone"
        case .terms:
            return "clipboard"
        case .privacy:
            return "person"
        case .apiReference:
            return "questionmark"
        case .numberOfMeals:
            return "number.circle"
        case .mealNames:
            return "takeoutbag.and.cup.and.straw"
        }
    }
    
    var key: String {
        return self.rawValue
    }
    
    var value: SettingValue {
        switch self {
        case .calorieTarget, .macroTargetProtein, .macroTargetFat, .macroTargetCarb:
            return .double
        case .numberOfMeals:
            return .integer
        case .mealNames:
            return .stringArray
        case .groceries, .nextPlan:
            return .date
        case .units:
            return .enumeration(Units.self)
        case .theme:
            return .enumeration(Theme.self)
        case .apiReference, .rateApp, .contactUs, .terms, .privacy:
            return .nilValue
        }
    }
}
