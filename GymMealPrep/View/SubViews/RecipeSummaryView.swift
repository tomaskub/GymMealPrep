//
//  RecipeSummaryView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/13/23.
//

import SwiftUI

struct RecipeSummaryView: View {
    
    enum SummaryComponent {
        case all, time, nutrition
    }
    // labels
    let timeLabels: [String] =  ["Prep", "Cook", "Wait", "Total"]
    let nutritionLabels: [String] = ["Cal", "Protein", "Fat", "Carb"]
    
    // time values in minutes
    let timePreparingInMinutes: Int?
    let timeCookingInMinutes: Int?
    let timeWaitingInMinues: Int?
    let timeTotalInMinutes: Int?
    
    // Nutrition values in grams
    let cal: Float?
    let proteinInGrams: Float?
    let fatInGrams: Float?
    let carbInGrams: Float?
    // Servings
    let servings: Int?
    /// Format for nutrition values
    let format: String?
    let gridSpacing: CGFloat
    
    let showNutritionLabel: Bool
    let showTimeLabel: Bool
    
    let typeOfComponents: SummaryComponent
    
    init(timePreparingInMinutes: Int, timeCookingInMinutes: Int, timeWaitingInMinues: Int, timeTotalInMinutes: Int, cal: Float, proteinInGrams: Float, fatInGrams: Float, carbInGrams: Float, servings: Int, format: String, showNutritionLabel: Bool = true, showTimeLabel: Bool = true, gridSpacing: CGFloat = 50) {
        self.timePreparingInMinutes = timePreparingInMinutes
        self.timeCookingInMinutes = timeCookingInMinutes
        self.timeWaitingInMinues = timeWaitingInMinues
        self.timeTotalInMinutes = timeTotalInMinutes
        self.showTimeLabel = showTimeLabel
        self.cal = cal
        self.proteinInGrams = proteinInGrams
        self.fatInGrams = fatInGrams
        self.carbInGrams = carbInGrams
        self.servings = servings
        self.format = format
        self.showNutritionLabel = showNutritionLabel
        self.typeOfComponents = .all
        self.gridSpacing = gridSpacing
    }
    
    init(timePreparingInMinutes: Int, timeCookingInMinutes: Int, timeWaitingInMinutes: Int, timeTotalInMinutes: Int, showLabel: Bool = true, gridSpacing: CGFloat = 50) {
        
        self.typeOfComponents = .time
        self.timePreparingInMinutes = timePreparingInMinutes
        self.timeCookingInMinutes = timeCookingInMinutes
        self.timeWaitingInMinues = timeWaitingInMinutes
        self.timeTotalInMinutes = timeTotalInMinutes
        self.showTimeLabel = showLabel
        self.gridSpacing = gridSpacing
        self.cal = nil
        self.proteinInGrams = nil
        self.fatInGrams = nil
        self.carbInGrams = nil
        self.servings = nil
        self.format = nil
        self.showNutritionLabel = false
    }
    
    init(cal: Float, proteinInGrams: Float, fatInGrams: Float, carbInGrams: Float, format: String, showLabel: Bool = true, gridSpacing: CGFloat = 50) {
        self.timePreparingInMinutes = nil
        self.timeCookingInMinutes = nil
        self.timeWaitingInMinues = nil
        self.timeTotalInMinutes = nil
        self.showTimeLabel = false
        
        self.cal = cal
        self.proteinInGrams = proteinInGrams
        self.fatInGrams = fatInGrams
        self.carbInGrams = carbInGrams
        self.servings = nil
        self.format = format
        self.typeOfComponents = .nutrition
        self.showNutritionLabel = showLabel
        
        self.gridSpacing = gridSpacing
    }
    
    
    
    var body: some View {
        
            Grid(horizontalSpacing: gridSpacing) {
                
                if typeOfComponents != .time {
                    if showNutritionLabel {
                        GridRow {
                            Text("Nutrition value:")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        .gridCellColumns(4)
                        .padding(.vertical)
                    }
                    
                    GridRow {
                        ForEach(generateNutritionData(), id: \.0) { data in
                            VStack {
                                Text(data.0)
                                Text(data.1)
                            }
                        }
                    }
                    .padding(.bottom)
                }
                
                if typeOfComponents != .nutrition{
                    
                    if showTimeLabel {
                        GridRow {
                            Text("Time:")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .gridCellColumns(4)
                        }
                        .padding(.bottom)
                    }
                    
                    GridRow {
                        ForEach(generateTimeData(), id: \.0) { data in
                            VStack {
                                Text(data.0)
                                Text(data.1)
                            }
                        }
                    }
                    .padding(.bottom)
                }
                
                if typeOfComponents == .all {
                    GridRow {
                        Text("Servings:")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .gridCellColumns(2)
                        Text("\(servings ?? 1)")
                    }
                    .padding(.bottom)
                }
            } // END OF GRID
    } // END OF BODY
    func generateTimeData() -> [(String, String)] {
        return [(timeLabels[0], "\(timePreparingInMinutes ?? 0)"),
                (timeLabels[1], "\(timeCookingInMinutes ?? 0)"),
                (timeLabels[2], "\(timeWaitingInMinues ?? 0)"),
                (timeLabels[3], "\(timeTotalInMinutes ?? 0)")]
    }
    func generateNutritionData() -> [(String, String)] {
        return [(nutritionLabels[0], String(format: format ?? "%.0f", cal ?? 0)),
                     (nutritionLabels[1], String(format: format ?? "%.0f", proteinInGrams ?? 0)),
                     (nutritionLabels[2], String(format: format ?? "%.0f", fatInGrams ?? 0)),
                     (nutritionLabels[3],String(format: format ?? "%.0f", carbInGrams ?? 0))]
    }
} // END OF STRUCT

struct RecipeSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray
            
            RecipeSummaryView(timePreparingInMinutes: 10, timeCookingInMinutes: 30, timeWaitingInMinues: 20, timeTotalInMinutes: 60, cal: 500, proteinInGrams: 35, fatInGrams: 12, carbInGrams: 25, servings: 4, format: "%.0f")
                        .background()
                        .cornerRadius(10)
            
        }
    }
}
