//
//  K.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 26/08/2023.
//

import Foundation

struct K {
    struct SettingKeys {
        static let calorieTarget = "calorie-target"
        static let macroTargetProtein = "macro-target-protein"
        static let macroTargetFat = "macro-target-fat"
        static let macroTargetCarb = "macro-target-carb"
        static let theme = "theme"
    }
    static let previewEnvironmentFlagKey = "XCODE_RUNNING_FOR_PREVIEWS"
    static let testingFlag = "-test"
}
