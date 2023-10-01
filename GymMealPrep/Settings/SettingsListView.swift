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
        VStack {
            List {
                ForEach(viewModel.settings) { sectionModel in
                    Section {
                        ForEach(sectionModel.items, id: \.self.id) { element in
                            Label {
                                Text(element.label)
                            } icon: {
                                Image(systemName: element.iconSystemName)
                            }
                        }
                    } header: {
                        Text(sectionModel.sectionName)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                }
            }
            Text("work in progress settings for\n GymMealPrep ❤︎ Tomasz Kubiak")
                .multilineTextAlignment(.center)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .navigationTitle("Settings")
    }
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

