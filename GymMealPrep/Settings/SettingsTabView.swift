//
//  SettingsTabView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 26/08/2023.
//

import SwiftUI

struct SettingsTabView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var path = NavigationPath()
    var body: some View {
        NavigationStack {
                SettingsListView(viewModel: viewModel, path: $path)
                .navigationDestination(for: SettingModel.self) { model in
                    SettingsDetailView(settingModels: [model], title: model.labelText)
                }
                .navigationDestination(for: SettingGroup.self) { group in
                    SettingsDetailView(settingModels: group.settings, title: group.labelText)
                }
        } // END OF NAV-STACK
    } // END OF BODY
} // END OF STRUCT

struct SettingsTabView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsTabView()
    }
}
