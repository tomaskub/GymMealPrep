//
//  SettingsViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 26/08/2023.
//

import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    
    @Published private var settingStore: SettingStore
    @Published var settings: [SettingSection] = []
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(settingStore: SettingStore) {
        self.settingStore = settingStore
        self.settings = createSettingSections()
        
        settingStore.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.settings = self.createSettingSections()
                self.objectWillChange.send()
            }.store(in: &cancellables)
        self.setNumberOfMealsUpdater()
    }
    
    private func createSettingSections() -> [SettingSection] {
        let dietSection = makeDietSettingSection()
        let mealPlanSection = makeSettingSection(name: "Meal Plan", items: [.numberOfMeals, .mealNames])
        let calendarSection = makeSettingSection(name: "Calendar", items: [.nextPlan, .groceries])
        let variousSection = makeSettingSection(name: "App", items: [.units, .theme])
        let informationSection = makeSettingSection(name: "Information",
                                                    items: [.rateApp, .privacy, .terms, .apiReference, .contactUs])
        return [dietSection, mealPlanSection, calendarSection, variousSection, informationSection]
    }
    
    private func setNumberOfMealsUpdater() {
        settingStore.$settings
            .receive(on: RunLoop.main)
            .flatMap { dictionary in
                dictionary.publisher.map { (key: $0.key, value: $0.value)}
            }
            .filter { (key, value) in
                key == Setting.numberOfMeals
            }
            .compactMap { (key, value) in
                value as? Int
            }
            .sink { [weak self] value in
                guard let self else { return }
                if var mealsArray = self.settingStore.settings[Setting.mealNames] as? [String] {
                    let diff = mealsArray.count - value
                    switch mealsArray.count - value {
                    case let diff where diff < 0:
                        mealsArray.append(contentsOf: Array(repeating: String(), count: abs(diff)))
                    case let diff where diff > 0:
                        mealsArray.removeLast(diff)
                    default:
                        break
                    }
                    self.settingStore.settings.updateValue(mealsArray, forKey: .mealNames)
                } else {
                    let mealsArray = Array(repeating: String(), count: value)
                    self.settingStore.settings.updateValue(mealsArray, forKey: .mealNames)
                }
                
            }.store(in: &cancellables)
    }
    
    private func makeDietSettingSection() -> SettingSection {
        return SettingSection(
            sectionName: "Diet",
            items: [
                makeSettingModel(setting: .calorieTarget),
                SettingGroup(
                    iconSystemName: "chart.pie",
                    labelText: "Macro targets",
                    tipText: "This is a tip text for macro targets",
                    settings: [
                        makeSettingModel(setting: .macroTargetProtein),
                        makeSettingModel(setting: .macroTargetFat),
                        makeSettingModel(setting: .macroTargetCarb)
                    ])
            ])
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
        case .double:
            if let value = settingStore.settings[setting] as? Double {
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
        case .enumeration(_):
            if let value = settingStore.settings[setting] as? any SettingEnum, let valueInString = value.rawValue as? String {
                stringValue = valueInString
            }
        }
        
        return SettingModel(setting: setting, valueText: stringValue, tipText: "This is a generic setting model tool tip")
    }
}
