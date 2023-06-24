//
//  MealPlanRowView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/24/23.
//

import SwiftUI

struct MealPlanRowView: View {
    
    let mealPlan: MealPlan
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(mealPlan.name ?? "Meal Plan")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("Total of \(mealPlan.meals.count) meals")
                .padding(.bottom, 4)
            
            RecipeSummaryView(cal: mealPlan.nutrition.calories, proteinInGrams: mealPlan.nutrition.protein, fatInGrams: mealPlan.nutrition.fat, carbInGrams: mealPlan.nutrition.carb, format: "%.0f", showLabel: false)
        }// END OF VSTACK
    } // END OF BODY
} // END OF STRUCT

struct MealPlanRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            MealPlanRowView(mealPlan: SampleData.sampleMealPlan)
        }
    }
}
