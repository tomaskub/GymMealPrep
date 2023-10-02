//
//  SettingsViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 26/08/2023.
//

import Foundation

class SettingsViewModel: ObservableObject {
    
    @Published private var settingStore: SettingStore
    @Published var settings: [SettingSection] = []
    
    init(settingStore: SettingStore = SettingStore()) {
        self.settingStore = settingStore
        self.settings = createSettingSections()
    }
    
    private func createSettingSections() -> [SettingSection] {
        var result = [SettingSection]()
        let dietSection = SettingSection(
            sectionName: "Diet",
            items: [
                makeSettingModel(setting: .calorieTarget),
                SettingGroup(
                    iconSystemName: "chart.pie",
                    labelText: "Macro targets",
                    settings: [
                        makeSettingModel(setting: .macroTargetProtein),
                        makeSettingModel(setting: .macroTargetFat),
                        makeSettingModel(setting: .macroTargetCarb)
                    ])
            ])
        let mealPlanSection = makeSettingSection(name: "Meal Plan", items: [.numberOfMeals, .mealNames])
        let calendarSection = makeSettingSection(name: "Calendar", items: [.nextPlan, .groceries])
        let variousSection = makeSettingSection(name: "App", items: [.units, .theme])
        let informationSection = makeSettingSection(name: "Information",
                                                    items: [.rateApp, .privacy, .terms, .apiReference, .contactUs])
        return [dietSection, mealPlanSection, calendarSection, variousSection, informationSection]
    }
    
    private func makeSettingSection(name: String, items: [Setting]) -> SettingSection {
        return SettingSection(
            sectionName: name,
            items: items.compactMap { makeSettingModel(setting: $0) }
        )
    }
    
    private func makeSettingModel(setting: Setting) -> SettingModel {
        var stringValue: String?
        switch setting.value {
        case .bool:
            if let value = settingStore.settings[setting] as? Bool {
                stringValue = String(value)
            }
        case .integer:
            if let value = settingStore.settings[setting] as? Int {
                stringValue = String(value)
            }
        case .date:
            if let value = settingStore.settings[setting] as? Date {
                stringValue = value.formatted(date: .abbreviated, time: .omitted)
            }
        case .string:
            stringValue = settingStore.settings[setting] as? String
        case .stringArray, .nilValue:
            stringValue = nil
        }
        
        return SettingModel(setting: setting, valueText: stringValue)
    }
}
