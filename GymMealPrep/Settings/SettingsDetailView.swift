//
//  SettingsDetailView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 30/09/2023.
//

import SwiftUI

struct SettingsDetailView: View {
    @State private var boolExample: Bool = false
    @State private var stringExample: String = .init()
    @State private var date: Date = Date()
    
    let settingModels: [SettingModel]
    let title: String
    
    var body: some View {
        List {
            // Placeholder
            ForEach(settingModels) { model in
                switch model.setting.value {
                case .integer:
                    makeTextRow(setting: model)
                case .bool:
                    makeBoolRow(setting: model)
                case .date:
                    makeDateRow(setting: model)
                default:
                    makePlaceholderRow(setting: model)
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
    @ViewBuilder
    private func makeDateRow(setting: SettingModel) -> some View {
        Text(date.formatted(date: .complete, time: .omitted))
        DatePicker("Date", selection: $date, displayedComponents: .date)
            .datePickerStyle(.graphical)
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
    private func makeTextRow(setting: SettingModel) -> some View {
        HStack {
            Label {
                Text(setting.labelText)
                    .fixedSize()
            } icon: {
                Image(systemName: setting.iconSystemName)
            }
            Spacer()
            TextField("placeholder", text: $stringExample)
                .textFieldStyle(.roundedBorder)
        }
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
    private func makeBoolRow(setting: SettingModel) -> some View {
        Section {
            Toggle("Sample setting", isOn: $boolExample)
            makeTooltip(text: "This is an description of the settings and a short instructions about how you should use it. The way it is constructed should be automatic depending on the data the view gets when it gets initiated. Additionaly it has to have a way to change the setting on dismiss or just in general")
                
        } header: {
            Text("This is a bool setting example")
        }
    }
    
    @ViewBuilder
    private func makeTooltip(text: String) -> some View {
        Text(text)
            .font(.caption)
            .foregroundColor(.gray)
    }
}

struct SettingsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsDetailView(settingModels: [SettingModel(setting: .nextPlan, valueText: "3100")], title: "Next meal plan")
        }
    }
}
