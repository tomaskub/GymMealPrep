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
    
    @State private var firstSlider: Double = 45
    @State private var secondSlider: Double = 30
    @State private var thirdSlider: Double = 25
    
    var body: some View {
        List {
            // Pie chart
            HStack {
                Spacer()
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
                Spacer()
                Grid(alignment: .leading) {
                    Text("Legend:")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    GridRow {
                        Rectangle()
                            .foregroundColor(.blue)
                            .frame(width: 14, height: 14)
                        Text(firstValueLabel)
                            .font(.caption)
                    }
                    GridRow {
                        Rectangle()
                            .foregroundColor(.yellow)
                            .frame(width: 14, height: 14)
                        Text(secondValueLabel)
                            .font(.caption)
                    }
                    GridRow {
                    Rectangle()
                            .foregroundColor(.green)
                            .frame(width: 14, height: 14)
                        Text(thirdValueLabel)
                            .font(.caption)
                    }
                }
            }
            .listRowBackground(Color.clear)
            // Controls
            Section {
                HStack {
                    Text("\(firstValueLabel): ")
                    Spacer()
                    Stepper(String(format: "%.0f", firstSlider) + "%",
                            value: $firstSlider,
                            in: firstStepperRange,
                            step: 1)
                    .fixedSize()
                }
                HStack {
                    Text("\(secondValueLabel): ")
                    Spacer()
                    Stepper(String(format: "%.0f", secondSlider) + "%",
                            value: $secondSlider,
                            in: secondStepperRange,
                            step: 1)
                    .fixedSize()
                }
                HStack {
                    Text("\(thirdValueLabel): ")
                    Spacer()
                    Stepper(String(format: "%.0f", thirdSlider) + "%",
                            value: $thirdSlider,
                            in: thirdStepperRange,
                            step: 1)
                    .fixedSize()
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
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
            SettingsMacroTargetsView()
        }
    }
}
