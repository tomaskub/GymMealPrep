//
//  MealPlanEditorView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/24/23.
//

import SwiftUI

struct MealPlanEditorView: View {
    @State var draftMealPlan: MealPlan
    
    var body: some View {
        List {
            
            Section("Meal plan") {
                
                Text(draftMealPlan.name ?? "Meal plan")
                
                RecipeSummaryView(cal: draftMealPlan.nutrition.calories, proteinInGrams: draftMealPlan.nutrition.protein, fatInGrams: draftMealPlan.nutrition.fat, carbInGrams: draftMealPlan.nutrition.carb, format: "%.0f", showLabel: false)
                    .frame(maxWidth: .infinity)
                    .font(.caption)
            } // END OF SECTION
            .listRowSeparator(.hidden)
            
            ForEach(Array(draftMealPlan.meals.enumerated()), id: \.element) { index, meal  in
                
                Section {
                    RecipeSummaryView(cal: meal.nutrition.calories, proteinInGrams: meal.nutrition.protein, fatInGrams: meal.nutrition.fat, carbInGrams: meal.nutrition.carb, format: "%.0f", showLabel: false)
                        .frame(maxWidth: .infinity)
                        .font(.caption)
                    
                    ForEach(meal.recipes) { recipe in
                        Text(recipe.name)
                    } // END OF FOR EACH
                    
                    ForEach(meal.ingredients) { ingredient in
                        Text(generateIngredientLabel(ingredient:ingredient))
                    } // END OF FOR EACH
                    
                    HStack {
                        Spacer()
                        Text("Add to meal ")
                        Spacer()
                    } // END OF H STACK
                    
                } header: {
                        Text("Meal #\(index + 1)")
                } // END OF HEADER
                .headerProminence(.increased)
            } // END OF FOR EACH
        } // END OF LIST
    } // END OF BODY
    
    func generateIngredientLabel(ingredient: Ingredient) -> String {
        return ingredient.food.name + " " + String(ingredient.quantity) + " " + ingredient.unitOfMeasure
    }
} // END OF STRUCT

struct MealPlanEditorView_Previews: PreviewProvider {
    static var previews: some View {
        MealPlanEditorView(draftMealPlan: SampleData.sampleMealPlan)
    }
}
