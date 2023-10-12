//
//  SettingModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 01/10/2023.
//

import Foundation

protocol SettingListable: Identifiable, Hashable {
    var id: UUID { get }
    var iconSystemName: String { get }
    var labelText: String { get }
    var valueText: String? { get }
    var tipText: String? { get }
}

struct SettingModel: SettingListable {
    let id: UUID = .init()
    let setting: Setting
    var valueText: String?
    let tipText: String?
    var iconSystemName: String { setting.systemImageName }
    var labelText: String { setting.label }
}

struct SettingGroup: SettingListable {
    let id: UUID = .init()
    let iconSystemName: String
    let labelText: String
    let tipText: String?
    var valueText: String? { return nil }
    var settings: [SettingModel]
}

struct SettingSection: Identifiable {
    let id: UUID = .init()
    let sectionName: String
    var items: [any SettingListable]
}
