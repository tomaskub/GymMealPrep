//
//  SettingEnum.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 22/10/2023.
//

import Foundation

protocol SettingEnum: Hashable, CaseIterable {
    associatedtype RawValue: Hashable = String
    var rawValue: RawValue { get }
    static var defaultValue: Self { get }
}
