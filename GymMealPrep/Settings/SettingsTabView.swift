//
//  SettingsTabView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 26/08/2023.
//

import SwiftUI

struct SettingsTabView: View {
    @StateObject private var viewModel = SettingsViewModel()
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SettingsTabView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsTabView()
    }
}
