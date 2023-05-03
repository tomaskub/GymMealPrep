//
//  SizePreferenceKey.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/3/23.
//

import Foundation
import SwiftUI

public struct SizePreferenceKey: PreferenceKey {
    public static var defaultValue: CGSize = .zero

    public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    }
}
