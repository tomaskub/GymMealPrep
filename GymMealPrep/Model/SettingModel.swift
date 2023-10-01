//
//  SettingModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 01/10/2023.
//

import Foundation

protocol SettingListable: Identifiable {
    var id: UUID { get }
    var iconSystemName: String { get }
    var label: String { get }
    var value: Any? { get }
}

struct SettingModel: SettingListable {
    let id: UUID = .init()
    let setting: Setting
    var value: Any?
    var iconSystemName: String {
        return setting.systemImageName
    }
    var label: String {
        return setting.label
    }
}

struct SettingGroup: SettingListable {
    let id: UUID = .init()
    let iconSystemName: String
    let label: String
    var value: Any? = nil
    var settings: [SettingModel]
}

struct SettingSection: Identifiable {
    let id: UUID = .init()
    let sectionName: String
    var items: [any SettingListable]
}
