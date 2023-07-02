//
//  MealPlanEditorView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/24/23.
//

import SwiftUI

struct MealPlanEditorView: View { //<T: MealPlanViewModelProtocol>: View {
    @ObservedObject var viewModel: MealPlanViewModel
    @State var selectedMeal: Meal?
    
    var body: some View {
        List {
            
            Section("Summary") {
                
                TextField("Meal plan name", text: $viewModel.mealPlanName)
                    .textFieldStyle(.roundedBorder)
                
                RecipeSummaryView(
                    cal: viewModel.mealPlan.nutrition.calories,
                    proteinInGrams: viewModel.mealPlan.nutrition.protein,
                    fatInGrams: viewModel.mealPlan.nutrition.fat,
                    carbInGrams: viewModel.mealPlan.nutrition.carb,
                    format: "%.0f",
                    showLabel: false)
                    .frame(maxWidth: .infinity)
                    .font(.caption)
            } // END OF SECTION
            .listRowSeparator(.hidden)
            
            ForEach(Array(viewModel.mealPlan.meals.enumerated()), id: \.element) { index, meal  in
                
                Section {
                    
                    RecipeSummaryView(
                        cal: meal.nutrition.calories,
                        proteinInGrams: meal.nutrition.protein,
                        fatInGrams: meal.nutrition.fat,
                        carbInGrams: meal.nutrition.carb,
                        format: "%.0f",
                        showLabel: false)
                        .frame(maxWidth: .infinity)
                        .font(.caption)
                    
                    ForEach(meal.recipes) { recipe in
                        Text(generateRecipeLabel(recipe: recipe))
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    viewModel.removeFromMeal(meal: meal, recipe)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    } // END OF FOR EACH

                    ForEach(meal.ingredients) { ingredient in
                        Text(generateIngredientLabel(ingredient:ingredient))
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    viewModel.removeFromMeal(meal: meal, ingredient)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    } // END OF FOR EACH
                    HStack {
                        Spacer()
                        Text("Add to meal")
                        Spacer()
                    } // END OF H STACK
                    .onTapGesture {
                        selectedMeal = meal
                    }
                    
                } header: {
                        Text("Meal #\(index + 1)")
                } // END OF HEADER
                .headerProminence(.increased)
            } // END OF FOR EACH
        } // END OF LIST
        .sheet(item: $selectedMeal) { _ in
            Text("Placeholder for editor sheet view")
            //TODO: REPLACE WITH IMPLEMENTATION OF MEALPLANEDITORSHEETVIEW WHEN READY
//            MealPlanEditorSheetView()
        }
    } // END OF BODY
    
    func generateIngredientLabel(ingredient: Ingredient) -> String {
        return ingredient.food.name + " " + String(ingredient.quantity) + " " + ingredient.unitOfMeasure
    }
    
    func generateRecipeLabel(recipe: Recipe) -> String {
        return recipe.name
    }
    
} // END OF STRUCT

struct MealPlanEditorView_Previews: PreviewProvider {
    static var previews: some View {
        MealPlanEditorView(viewModel: MealPlanViewModel(mealPlan: SampleData.sampleMealPlan, dataManager: DataManager.preview))
        
    }
}
