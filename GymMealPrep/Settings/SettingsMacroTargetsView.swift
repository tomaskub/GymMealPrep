//
//  SwiftUIView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 16/10/2023.
//

import SwiftUI
import Charts

struct SettingsMacroTargetsView: View {
    let title: String
    @StateObject private var vm: SettingsDetailViewModel
    
    init(title: String, vm: SettingsDetailViewModel) {
        self.title = title
        self._vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        List {
            // Pie chart
            HStack {
                Spacer()
                makePieChart()
                Spacer()
                makeLegendView()
            }
            .listRowBackground(Color.clear)
            // Controls
            Section {
                ForEach(vm.settingModels) { model in
                    makeControlRow(
                        title: model.labelText,
                        value: vm.binding(type: Double.self, for: model.setting),
                        range: makeRange(for: model, in: vm.settingModels))
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func makeControlRow(title: String, value: Binding<Double>, range: ClosedRange<Double>) -> some View {
        HStack {
            Text(title)
            Spacer()
            Stepper(String(format: "%.0f", value.wrappedValue) + "%",
                    value: value,
                    in: range,
                    step: 1)
            .fixedSize()
        }
    }
    
    private func makeRange(for targetModel: SettingModel, in modelGroup: [SettingModel]) -> ClosedRange<Double> {
        let values: [Double] = {
            var finalGroup = modelGroup
            finalGroup.removeAll { model in
                targetModel.id == model.id
            }
            return finalGroup.map { model in
                if let result = vm.settingValues[model.setting] as? Double {
                    return result
                } else {
                    return 0.0
                } }
        }()
        let upperRange = (100-values.reduce(0.0, +))
        return 0...upperRange
    }
    
    @ViewBuilder
    private func makePieChart() -> some View {
        Circle()
            .frame(width: 175)
            .foregroundColor(.secondary)
            .overlay {
                makeChartSegments()
            }
    }
    
    @ViewBuilder
    private func makeChartSegments() -> some View {
        let data = makePieSegmentData()
        let colors: [Color] = [.blue, .yellow, .green, .red, .brown]
        ForEach(Array(vm.settingModels.enumerated()), id: \.element) { (i, model) in
            if let (startAngle, finishAngle) = data[model.setting] {
                PieSegment(start:startAngle , end: finishAngle)
                    .foregroundColor(colors[i])
            }
        }
    }
    
    private func makePieSegmentData() -> [Setting : (Angle, Angle)] {
        var result: [Setting : (Angle, Angle)] = .init()
        for (i, model) in vm.settingModels.enumerated() {
            var startAngle = Angle.zero
            if i > 0 {
                let key = vm.settingModels[i-1].setting
                startAngle = result[key]?.1 ?? .zero
            }
            var finishAngle = startAngle
            if let value = vm.settingValues[model.setting] as? Double {
                let angleDiff = Angle(degrees: 3.6*value)
                finishAngle += angleDiff
            }
            // update data
            result.updateValue((startAngle, finishAngle), forKey: model.setting)
        }
        return result
    }
    
    @ViewBuilder
    private func makeLegendView() -> some View {
        let colors: [Color] = [.blue, .yellow, .green, .red, .brown]
        Grid(alignment: .leading) {
            Text("Legend:")
                .font(.caption2)
                .foregroundColor(.secondary)
            ForEach(Array(vm.settingModels.enumerated()), id: \.element) { (i, model) in
                GridRow {
                    Rectangle()
                        .foregroundColor(colors[i])
                        .frame(width: 14, height: 14)
                    Text(model.labelText)
                        .font(.caption)
                }
            }
        }
    }
    
    private struct PieSegment: Shape {
        var start: Angle
        var end: Angle

        func path(in rect: CGRect) -> Path {
            var path = Path()
            let center = CGPoint(x: rect.midX, y: rect.midY)
            path.move(to: center)
            path.addArc(center: center, radius: rect.midX, startAngle: start, endAngle: end, clockwise: false)
            return path
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    
    private struct PreviewContainerView: View {
        @StateObject private var container = ContainerFactory.build()
        
        var body: some View {
            NavigationStack{
                SettingsMacroTargetsView(title: "Macro targets",
                                         vm: SettingsDetailViewModel(
                                            settingStore: container.settingStore,
                                            settingModels: [
                                                SettingModel(setting: .macroTargetProtein, tipText: nil),
                                                SettingModel(setting: .macroTargetFat, tipText: nil),
                                                SettingModel(setting: .macroTargetCarb, tipText: nil),
                                            ]
                                         )
                )
            }
        }
    }
    static var previews: some View {
        PreviewContainerView()
    }
}
