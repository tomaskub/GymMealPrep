//
//  Units.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 22/10/2023.
//

import Foundation

enum Units: String, SettingEnum, Initializable {
    static var defaultValue: Units = .metric
    
    case metric, imperial
    init() {
        self = Units.defaultValue
    }
}
