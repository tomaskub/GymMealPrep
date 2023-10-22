//
//  SettingGroup.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 22/10/2023.
//

import Foundation

struct SettingGroup: SettingListable {
    let id: UUID = .init()
    let iconSystemName: String
    let labelText: String
    let tipText: String?
    var valueText: String? { return nil }
    var settings: [SettingModel]
}
