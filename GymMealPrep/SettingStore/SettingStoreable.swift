//
//  SettingStoreable.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 31/10/2023.
//

import Foundation

class SettingStoreable: ObservableObject {
    @Published var settings: [Setting : Any?] = .init()
}
