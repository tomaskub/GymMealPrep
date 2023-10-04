//
//  SettingsDetailView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 30/09/2023.
//

import SwiftUI

struct SettingsDetailView: View {
    
    let title: String
    @StateObject private var viewModel: SettingsDetailViewModel
    
    init(title: String, viewModel: SettingsDetailViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.title = title
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.settingModels) { model in
                    switch model.setting.value {
                    case .integer:
                        makeIntRow(setting: model,
                                   value: viewModel.binding(type: Int.self, for: model.setting))
                    case .string:
                        makeTextRow(setting: model,
                                    value: viewModel.binding(type: String.self, for: model.setting))
                    case .bool:
                        makeBoolRow(setting: model,
                                    value: viewModel.binding(type: Bool.self, for: model.setting))
                    case .date:
                        makeDateRow(setting: model,
                                    value: viewModel.binding(type: Date.self, for: model.setting))
                    case .stringArray:
                        makeStringArrayRows()
                    case .nilValue:
                        makePlaceholderRow(setting: model)
                    }
                }
            }
        }
        makeViewFooter()
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: VIEW BUILDERS
extension SettingsDetailView {
    
    @ViewBuilder
    private func makeDateRow(setting: SettingModel, value: Binding<Date>) -> some View {
        Text(value.wrappedValue.formatted(date: .complete, time: .omitted))
        DatePicker("Date", selection: value, displayedComponents: .date)
            .datePickerStyle(.graphical)
    }
    
    @ViewBuilder
    private func makeTextRow(setting: SettingModel, value: Binding<String>) -> some View {
        HStack {
            Label {
                Text(setting.labelText)
                    .fixedSize()
            } icon: {
                Image(systemName: setting.iconSystemName)
            }
            Spacer()
            TextField("placeholder", text: value)
                .textFieldStyle(.roundedBorder)
        }
    }
    
    //TODO: COMPLETE VIEW BUILDERS
    @ViewBuilder
    private func makeStringArrayRows() -> some View {
        Text("Placeholder")
    }
    
    @ViewBuilder
    private func makeIntRow(setting: SettingModel, value: Binding<Int>) -> some View {
        Text("Placeholder")
    }
    
    @ViewBuilder
    private func makePickerRow(setting: SettingModel) -> some View {
        Section {
            Text("picker thing?")
        } header: {
            Text("Picker wheel example")
        }
    }
    
    @ViewBuilder
    private func makeBoolRow(setting: SettingModel, value: Binding<Bool>) -> some View {
        Section {
            Toggle(setting.labelText, isOn: value)
            makeTooltip(text: "This is an description of the settings and a short instructions about how you should use it. The way it is constructed should be automatic depending on the data the view gets when it gets initiated. Additionaly it has to have a way to change the setting on dismiss or just in general")
                
        } header: {
            Text("This is a bool setting example")
        }
    }
    
    @ViewBuilder
    private func makePlaceholderRow(setting: SettingModel) -> some View {
        HStack {
            Text(setting.labelText)
            Spacer()
            if let value = setting.valueText {
                Text(value)
            }
        }
    }
    
    @ViewBuilder
    private func makeTooltip(text: String) -> some View {
        Text(text)
            .font(.caption)
            .foregroundColor(.gray)
    }
    
    @ViewBuilder
    private func makeViewFooter() -> some View {
        Text("work in progress settings detail view for\n GymMealPrep ❤︎ Tomasz Kubiak")
            .multilineTextAlignment(.center)
            .font(.caption2)
            .foregroundColor(.secondary)
    }
}

struct SettingsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsDetailView(
                title: "Preview",
                viewModel: SettingsDetailViewModel(
                    settingStore: SettingStore(),
                    settingModels: [
                        SettingModel(setting: .privacy),
                        SettingModel(setting: .groceries)
                    ])
            )
        }
    }
}
