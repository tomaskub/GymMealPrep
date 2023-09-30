//
//  SettingsStore.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 27/09/2023.
//

import Foundation
import Combine

class SettingStore: ObservableObject {
    
    enum Setting: String {
        case calorieTarget
        case macroTargetProtein
        case macroTargetFat
        case macroTargetCarb
        case useImperial
        case theme
        
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
            case .useImperial:
                return "Use imperial units"
            }
        }
        
        var key: String {
            return self.rawValue
        }
    }
    
    private let defaults = UserDefaults.standard
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var calorieTarget: Int
    @Published var proteinTarget: Int
    @Published var fatTarget: Int
    @Published var carbTarget: Int
    @Published var useImperial: Bool
    init() {
        self.calorieTarget = defaults.integer(forKey: Setting.calorieTarget.key)
        self.proteinTarget = defaults.integer(forKey: Setting.macroTargetProtein.key)
        self.fatTarget = defaults.integer(forKey: Setting.macroTargetFat.key)
        self.carbTarget = defaults.integer(forKey: Setting.macroTargetCarb.key)
        self.useImperial = defaults.bool(forKey: Setting.useImperial.key)
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
