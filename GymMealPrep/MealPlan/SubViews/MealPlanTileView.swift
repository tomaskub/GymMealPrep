//
//  MealPlanTileView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 7/1/23.
//

import SwiftUI

struct MealPlanTileView: View {
    let mealPlan: MealPlan
    
    let formatter: NumberFormatter = {
       let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter
    }()
    
    var body: some View {
        Grid(alignment: .leading, verticalSpacing: 4) {
            GridRow {
                Text(mealPlan.name ?? "Unnamed plan")
                    .font(.body)
            }
            .gridCellColumns(2)
            
            GridRow {
            Text("Calories")
                    .foregroundColor(.gray)
                Text(formatedValue(mealPlan.nutrition.calories))
            }
            
            GridRow {
                Text("Fats")
                    .foregroundColor(.gray)
                Text(formatedValue(mealPlan.nutrition.fat))
            }
            
            GridRow {
                Text("Carbs")
                    .foregroundColor(.gray)
                Text(formatedValue(mealPlan.nutrition.carb))
            }
            
            GridRow {
                Text("Proteins")
                    .foregroundColor(.gray)
                Text(formatedValue(mealPlan.nutrition.protein))
            }
        } // END OF GRID
        .font(.caption)
    } // END OF BODY
    
    private func formatedValue(_ value: Float) -> String {
        formatter.string(from: NSNumber(value: value)) ?? "0.0"
    }
}

struct MealPlanTileView_Previews: PreviewProvider {
    static var previews: some View {
        MealPlanTileView(mealPlan: SampleData.sampleMealPlan)
    }
}
