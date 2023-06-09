//
//  ViewWidthKey.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/9/23.
//

import SwiftUI

struct ViewWidthKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
