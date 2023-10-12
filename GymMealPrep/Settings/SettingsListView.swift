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
    @State var testing: Int = 1
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.settings) { sectionModel in
                    Section {
                        ForEach(sectionModel.items, id: \.self.id) { element in
                                NavigationLink(value: element) {
                                    makeSettingsRow(element: element)
                                }
                        }
                    } header: {
                        makeSectionHeader(sectionModel)
                    }
                }
            }
            makeViewFooter()
        }
        .navigationTitle("Settings")
    }

    @ViewBuilder
    private func makeSettingsRow(element: any SettingListable) -> some View {
        HStack {
            Label {
                Text(element.labelText)
            } icon: {
                Image(systemName: element.iconSystemName)
            }
            Spacer()
            if let value = element.valueText {
                Text(value)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    @ViewBuilder
    private func makeSectionHeader(_ sectionModel: SettingSection) -> some View {
        Text(sectionModel.sectionName)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
    }
    
    @ViewBuilder
    private func makeViewFooter() -> some View {
        Text("work in progress settings for\n GymMealPrep ❤︎ Tomasz Kubiak")
            .multilineTextAlignment(.center)
            .font(.caption2)
            .foregroundColor(.secondary)
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

