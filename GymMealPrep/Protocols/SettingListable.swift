//
//  SettingListable.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 22/10/2023.
//

import Foundation

protocol SettingListable: Identifiable, Hashable {
    var id: UUID { get }
    var iconSystemName: String { get }
    var labelText: String { get }
    var valueText: String? { get }
    var tipText: String? { get }
}
