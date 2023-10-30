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
                    case .double:
                        makeDoubleRow(setting: model,
                                      value: viewModel.binding(type: Double.self, for: model.setting))
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
                        makeStringArraySection(settingModel: model)
                    case .nilValue:
                        makePlaceholderRow(setting: model)
                    case .enumeration(let type):
                        if type is Units.Type {
                            makeGenericPickerRow(binding: viewModel.binding(type: Units.self, for: model.setting),
                                                 setting: model)
                        } else if type is Theme.Type {
                            makeGenericPickerRow(binding: viewModel.binding(type: Theme.self, for: model.setting),
                                                 setting: model)
                        }
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

    @ViewBuilder
    private func makeIntRow(setting: SettingModel, value: Binding<Int>) -> some View {
        Stepper("\(setting.labelText): \(value.wrappedValue)",
                value: value,
                in: 1...99)
    }
    @ViewBuilder
    private func makeDoubleRow(setting: SettingModel, value: Binding<Double>) -> some View {
        
        let bindingString = Binding(
            get: { () -> String in
                let stringValue = String(value.wrappedValue)
                if stringValue.hasSuffix(".0") {
                    return String(format: "%.0f", value.wrappedValue)
                } else {
                    return stringValue
                }
            }, set: { newValue in
                if let _value = Double(newValue) {
                    if !newValue.hasSuffix(".") {
                        value.wrappedValue = _value
                    }
                } else if newValue.isEmpty {
                    value.wrappedValue = Double()
                }
            }
          )
        
        HStack {
            Label {
                Text(setting.labelText)
                    .fixedSize()
            } icon: {
                Image(systemName: setting.iconSystemName)
            }
            Spacer()
            TextField("placeholder",
                      text: bindingString
            )
            .textFieldStyle(.roundedBorder)
        }
    }
    
    @ViewBuilder
    private func makeStringArraySection(settingModel: SettingModel) -> some View {
        if let array = viewModel.settingValues[settingModel.setting] as? [String] {
            ForEach(Array(array.enumerated()), id: \.offset) { index, element in
                HStack {
                    Text("\(index+1).")
                    TextField(String(), text: viewModel.bindingArray(type: String.self, for: settingModel.setting, at: index))
                        .textFieldStyle(.roundedBorder)
                }
            }
        }
        //REMOVED UNTIL VAR SYNC IMPLEMENTED IN SETTINGS VIEW MODEL
//            .onDelete { indexSet in
//                viewModel.removeFromArray(for: settingModel.setting, atOffsets: indexSet)
//            }
//        }
//        Button {
//            viewModel.appendToArray(for: settingModel.setting, newValue: String())
//        } label: {
//            Label("Add", systemImage: "plus.circle")
//        }
    }

    @ViewBuilder
    private func makeGenericPickerRow<T>(binding: Binding<T>, setting: SettingModel) -> some View where T: SettingEnum, T.RawValue: StringProtocol {
        Picker(String(), selection: binding) {
            ForEach(Array(T.allCases), id: \.self) { enumCase in
                Text(String(describing: enumCase))
                    .tag(enumCase)
            }
        }
        .labelsHidden()
        .pickerStyle(.inline)
    }
    
    //TODO: COMPLETE VIEW BUILDERS + ADD STEPPER VIEW
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
        //this is for when there is no value associated with model - ie. information page
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
    private struct PreviewContainerView: View {
        @StateObject private var container = Container()
        var body: some View {
            NavigationStack {
                SettingsDetailView(
                    title: "Preview",
                    viewModel: SettingsDetailViewModel(
                        settingStore: container.settingStore,
                        settingModels: [
                            SettingModel(setting: .mealNames, valueText: nil, tipText: "Preview tooltip")
                        ])
                )
            }
            .environmentObject(container)
        }
    }
    static var previews: some View {
        PreviewContainerView()
    }
}
