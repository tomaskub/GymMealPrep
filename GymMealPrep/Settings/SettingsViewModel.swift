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
                    label: "Macro targets",
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
        let variousSetting = SettingSection(sectionName: "Various", items: [
            makeSettingModel(setting: .units),
            makeSettingModel(setting: .theme)
        ])
        result.append(dietSection)
        result.append(mealPlanSection)
        result.append(variousSetting)
        return result
    }
    
    private func makeSettingModel(setting: Setting) -> SettingModel {
        return SettingModel(setting: setting, value: settingStore.settings[setting] as Any?)
    }
}
