//
//  SettingsListView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 26/08/2023.
//

import SwiftUI

struct SettingsListView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @Binding var path: NavigationPath
    var body: some View {
        List {
            ForEach(viewModel.setingsArray) { setting in
                HStack {
                    Text(setting.setting.label)
                    Spacer()
                    Text(String(setting.value))
                }
            } // END OF FOR-EACH
        } // END OF LIST
        .navigationTitle("Settings")
    } // END OF BODY
} // END OF STRUCT

struct SettingsListView_Previews: PreviewProvider {
    struct Container: View {
        @StateObject private var vm = SettingsViewModel()
        @State private var path = NavigationPath()
        var body: some View {
            NavigationStack(path: $path) {
                SettingsListView(viewModel: vm, path: $path)
            }
        }
    }
    static var previews: some View {
        Container()
    }
}

