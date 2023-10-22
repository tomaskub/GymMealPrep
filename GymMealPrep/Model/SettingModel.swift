//
//  SettingModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 01/10/2023.
//

import Foundation

struct SettingModel: SettingListable {
    let id: UUID = .init()
    let setting: Setting
    var valueText: String?
    let tipText: String?
    var iconSystemName: String { setting.systemImageName }
    var labelText: String { setting.label }
}
