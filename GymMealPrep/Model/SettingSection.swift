//
//  SettingSection.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 22/10/2023.
//

import Foundation

struct SettingSection: Identifiable {
    let id: UUID = .init()
    let sectionName: String
    var items: [any SettingListable]
}
