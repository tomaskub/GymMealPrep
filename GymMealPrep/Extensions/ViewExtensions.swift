//
//  ViewExtensions.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/3/23.
//

import Foundation
import SwiftUI

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear.preference(key: SizePreferenceKey.self, value: proxy.size)
            })
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}
