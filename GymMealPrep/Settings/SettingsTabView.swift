//
//  SettingsTabView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 26/08/2023.
//

import SwiftUI

class Container: ObservableObject {
    var settingStore: SettingStore = .init()
}

struct SettingsTabView: View {
    
    @EnvironmentObject private var container: Container
    @StateObject private var viewModel = SettingsViewModel()
    @State private var path = NavigationPath()
    
    init(viewModel: SettingsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.path = NavigationPath()
    }
    
    var body: some View {
        NavigationStack {
                SettingsListView(viewModel: viewModel, path: $path)
                .navigationDestination(for: SettingModel.self) { model in
                    SettingsDetailView(title: model.labelText,
                                       viewModel: SettingsDetailViewModel(
                                        settingStore: container.settingStore,
                                        settingModels: [model]
                                       )
                    )
                }
                .navigationDestination(for: SettingGroup.self) { group in
                    if group.labelText == "Macro targets" {
                        SettingsMacroTargetsView(title: group.labelText,
                                                 vm: SettingsDetailViewModel(
                                                    settingStore: container.settingStore,
                                                    settingModels: group.settings
                                                 )
                        )
                    } else {
                        SettingsDetailView(title: group.labelText,
                                           viewModel: SettingsDetailViewModel(
                                            settingStore: container.settingStore,
                                            settingModels: group.settings
                                           )
                        )
                    }
                }
        } // END OF NAV-STACK
    } // END OF BODY
} // END OF STRUCT

struct SettingsTabView_Previews: PreviewProvider {
    
    struct PreviewContainer: View {
        @StateObject private var container: Container = .init()
        var body: some View {
            SettingsTabView(viewModel: SettingsViewModel(settingStore: container.settingStore))
                .environmentObject(container)
        }
    }
    
    static var previews: some View {
        PreviewContainer()
    }
}
