//
//  RecipeSummaryView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/13/23.
//

import SwiftUI

struct RecipeSummaryView: View {
    
    
    // labels
    let timeLabels: [String] =  ["Prep", "Cook", "Wait", "Total"]
    let nutritionLabels: [String] = ["Cal", "Protein", "Fat", "Carb"]
    
    // time values in minutes
    let timePreparingInMinutes: Int
    let timeCookingInMinutes: Int
    let timeWaitingInMinues: Int
    let timeTotalInMinutes: Int
    
    // Nutrition values in grams
    let cal: Float
    let proteInInGrams: Float
    let fatInGrams: Float
    let carbInGrams: Float
    
    let servings: Int
    
    let format: String
    
    var body: some View {
        
            Grid(horizontalSpacing: 50) {
                GridRow {
                    Text("Nutrition value:")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                
                .gridCellColumns(4)
                .padding(.vertical)
                
                GridRow {
                    ForEach(generateNutritionData(), id: \.0) { data in
                        VStack {
                            Text(data.0)
                            Text(data.1)
                        }
                    }
                }
                .padding(.bottom)
                
                GridRow {
                    Text("Time:")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .gridCellColumns(4)
                }
                .padding(.bottom)
                
                GridRow {
                    ForEach(generateTimeData(), id: \.0) { data in
                        VStack {
                            Text(data.0)
                            Text(data.1)
                        }
                    }
                }
                .padding(.bottom)
                
                GridRow {
                    Text("Servings:")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .gridCellColumns(2)
                    Text("\(servings)")
                }
                .padding(.bottom)
            } // END OF GRID
            
            .background()
            .cornerRadius(10)
    } // END OF BODY
    func generateTimeData() -> [(String, String)] {
        return [(timeLabels[0], "\(timePreparingInMinutes)"),
                (timeLabels[1], "\(timeCookingInMinutes)"),
                (timeLabels[2], "\(timeWaitingInMinues)"),
                (timeLabels[3], "\(timeTotalInMinutes)")]
    }
    func generateNutritionData() -> [(String, String)] {
        return [(nutritionLabels[0], String(format: format, cal)),
                     (nutritionLabels[1], String(format: format, proteInInGrams)),
                     (nutritionLabels[2], String(format: format, fatInGrams)),
                     (nutritionLabels[3],String(format: format, carbInGrams))]
    }
} // END OF STRUCT

struct RecipeSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray
            
            RecipeSummaryView(timePreparingInMinutes: 10, timeCookingInMinutes: 30, timeWaitingInMinues: 20, timeTotalInMinutes: 60, cal: 500, proteInInGrams: 35, fatInGrams: 12, carbInGrams: 25, servings: 4, format: "%.0f")
            
        }
    }
}
