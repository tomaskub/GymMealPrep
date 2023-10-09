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
                            if let elementForEnum = element as? SettingModel,
                                case .enumeration(let enumType) = elementForEnum.setting.value {
                                    makePickerRow(element: elementForEnum, enumType: enumType)
                            } else {
                                NavigationLink(value: element) {
                                    makeSettingsRow(element: element)
                                }
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
    private func makePickerRow(element: SettingModel, enumType: any SettingEnum.Type) -> some View {
        if enumType is Units.Type || enumType is Theme.Type {
            Picker(selection: $testing) {
                Text("1").tag(1)
                Text("2").tag(2)
                Text("3").tag(3)
            } label: {
                Label(element.setting.label, systemImage: element.iconSystemName)
            }
            .pickerStyle(.navigationLink)
        }
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

