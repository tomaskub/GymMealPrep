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
        let mealPlanSection = SettingSection(
            sectionName: "Meal Plan",
            items: [
                makeSettingModel(setting: .numberOfMeals),
                makeSettingModel(setting: .mealNames)
            ])
        let calendarSection = SettingSection(
            sectionName: "Calendar",
            items: [
                makeSettingModel(setting: .nextPlan),
                makeSettingModel(setting: .groceries)
            ])
        let variousSection = SettingSection(sectionName: "Various", items: [
            makeSettingModel(setting: .units),
            makeSettingModel(setting: .theme),
        ])
        
        let informationSection = SettingSection(
            sectionName: "Information",
            items: [
                makeSettingModel(setting: .rateApp),
                makeSettingModel(setting: .privacy),
                makeSettingModel(setting: .terms),
                makeSettingModel(setting: .apiReference),
                makeSettingModel(setting: .contactUs)
            ])
        
        result.append(dietSection)
        result.append(mealPlanSection)
        result.append(calendarSection)
        result.append(variousSection)
        result.append(informationSection)
        return result
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
