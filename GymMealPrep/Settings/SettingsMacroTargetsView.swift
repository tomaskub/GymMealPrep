//
//  SwiftUIView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 16/10/2023.
//

import SwiftUI
import Charts

struct SettingsMacroTargetsView: View {
    let title: String = "Macro targets"
    let firstValueLabel: String = "Protein"
    let secondValueLabel: String = "Fat"
    let thirdValueLabel: String = "Carb"
    
    var firstStepperRange: ClosedRange<Double> {
        let max = 100.0 - secondSlider - thirdSlider
        return 0...max
    }
    var secondStepperRange: ClosedRange<Double> {
        let max = 100 - firstSlider - thirdSlider
        return 0...max
    }
    var thirdStepperRange: ClosedRange<Double> {
        let max = 100 - firstSlider - secondSlider
        return 0...max
    }
    @StateObject private var vm: SettingsDetailViewModel
    
    init(vm: SettingsDetailViewModel) {
        self._vm = StateObject(wrappedValue: vm)
    }
    
    @State private var firstSlider: Double = 45
    @State private var secondSlider: Double = 30
    @State private var thirdSlider: Double = 25
    
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
        return 0...(100-values.reduce(0.0, +))
    }
    
    @ViewBuilder
    private func makePieChart() -> some View {
        Circle()
            .frame(width: 175)
            .foregroundColor(.secondary)
            .overlay {
                PieSegment(start: .zero, end: Angle(degrees: 3.6*firstSlider))
                    .foregroundColor(.blue)
                PieSegment(start: Angle(degrees: 3.6*firstSlider), end: Angle(degrees: 3.6*firstSlider) + Angle(degrees: 3.6*secondSlider))
                    .foregroundColor(.yellow)
                PieSegment(start: Angle(degrees: 3.6*firstSlider) + Angle(degrees: 3.6*secondSlider), end: Angle(degrees: 3.6*firstSlider) + Angle(degrees: 3.6*secondSlider) + Angle(degrees: 3.6*thirdSlider))
                    .foregroundColor(.green)
            }
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
    static var previews: some View {
        NavigationStack{
            SettingsMacroTargetsView(vm: SettingsDetailViewModel(
                settingStore: SettingStore(),
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
