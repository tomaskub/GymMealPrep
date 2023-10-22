//
//  SettingValue.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 22/10/2023.
//

import Foundation

enum SettingValue: Hashable {
    case integer
    case double
    case bool
    case string
    case stringArray
    case date
    case nilValue
    case enumeration(any SettingEnum.Type)
    
    static func == (lhs: SettingValue, rhs: SettingValue) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
            switch self {
            case .enumeration(let type):
                // Hash the type's description to ensure uniqueness
                hasher.combine(ObjectIdentifier(type).hashValue)
            case .integer:
                hasher.combine("integer".hashValue)
            case .double:
                hasher.combine("double".hashValue)
            case .bool:
                hasher.combine("bool".hashValue)
            case .string:
                hasher.combine("string".hashValue)
            case .stringArray:
                hasher.combine("stringArray".hashValue)
            case .date:
                hasher.combine("date".hashValue)
            case .nilValue:
                hasher.combine("nilValue".hashValue)
            }
        }
}
