//
//  LoadingView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 18/08/2023.
//

import SwiftUI

struct LoadingView: View {
    var actionText: String
    var body: some View {
        ZStack {
            Color.white.opacity(0.93)
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(.circular)
                    
                Text(actionText)
                    .foregroundColor(.blue)
                    .accessibilityIdentifier("loading-action-text")
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
            LoadingView(actionText: "Loading recipe from web")
    }
}
