//
//  MealPlanDetailView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 7/1/23.
//

import SwiftUI

struct MealPlanDetailView<T: MealPlanViewModelProtocol>: View {
    
    @ObservedObject var viewModel: T
    
    var body: some View {
        List {
            
            Section("Summary") {
                
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
                        Text(generateRecipeLabel(recipe))
                    } // END OF FOR EACH
                    
                    ForEach(meal.ingredients) { ingredient in
                        Text(generateIngredientLabel(ingredient))
                    } // END OF FOR EACH
                    
                    
                } header: {
                        Text("Meal #\(index + 1)")
                } // END OF HEADER
            } // END OF FOR EACH
        } // END OF LIST
        .listStyle(.inset)
        .navigationTitle(viewModel.mealPlan.name ?? "Meal plan")
    } // END OF BODY
    
    func generateIngredientLabel(_ ingredient: Ingredient) -> String {
        return ingredient.food.name + " " + String(ingredient.quantity) + " " + ingredient.unitOfMeasure
    }
    
    func generateRecipeLabel(_ recipe: Recipe) -> String {
        return recipe.name
    }
}

struct MealPlanDetailView_Previews: PreviewProvider {
    struct PreviewContainer: View {
        @StateObject private var container: Container
        @StateObject private var viewModel: MealPlanViewModel
        @State private var navigationPath: NavigationPath
        
        init() {
            let container = ContainerFactory.build()
            self._container = StateObject(wrappedValue: container)
            self._viewModel = StateObject(wrappedValue: .init(mealPlan: SampleData.sampleMealPlan,
                                                              dataManager: container.dataManager))
            self._navigationPath = State(wrappedValue: NavigationPath())
        }
        
        var body: some View {
            NavigationStack {
                MealPlanDetailView(viewModel: viewModel)
            }
        }
    }
    static var previews: some View {
        PreviewContainer()
    }
}
