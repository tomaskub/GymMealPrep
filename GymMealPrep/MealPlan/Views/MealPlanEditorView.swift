//
//  MealPlanEditorView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/24/23.
//

import SwiftUI

struct MealPlanEditorView<T: MealPlanViewModelProtocol>: View {
    @ObservedObject var viewModel: T
    @Binding var navigationPath: NavigationPath
    let title: String
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
                        viewModel.selectedMeal = meal
                    }
                    
                } header: {
                        Text("Meal #\(index + 1)")
                } // END OF HEADER
                .headerProminence(.increased)
            } // END OF FOR EACH
            HStack {
                Spacer()
                Text("Add new meal")
                Spacer()
            }
            .onTapGesture {
                viewModel.addMeal()
            }
        } // END OF LIST
        .sheet(item: $viewModel.selectedMeal) { _ in
            MealPlanEditorSheetView(saveHandler: viewModel as MealPlanEditorSheetView.MealPlanEditorSaveHandler, navigationPath: $navigationPath)
        }
        .navigationTitle(title)
    } // END OF BODY
    
    func generateIngredientLabel(ingredient: Ingredient) -> String {
        return ingredient.food.name + " " + String(ingredient.quantity) + " " + ingredient.unitOfMeasure
    }
    
    func generateRecipeLabel(recipe: Recipe) -> String {
        return recipe.name
    }
    
} // END OF STRUCT

struct MealPlanEditorView_Previews: PreviewProvider {
    struct Containter: View {
        @State var navigationPath = NavigationPath()
        var body: some View {
            NavigationStack {
                MealPlanEditorView(viewModel: MealPlanViewModel(mealPlan: SampleData.sampleMealPlan, dataManager: DataManager.preview), navigationPath: $navigationPath, title: "Adding new meal plan")
            }
        }
    }
    static var previews: some View {
        Containter()
    }
}
