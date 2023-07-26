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
            
            mealPlanSummarySection
            
            ForEach(Array(viewModel.mealPlan.meals.enumerated()), id: \.element) { index, meal  in
                generateMealSection(index: index, meal: meal)
            } // END OF FOR EACH
            
            addNewMealButton
        } // END OF LIST
        
        .sheet(item: $viewModel.selectedMeal) { _ in
            MealPlanEditorSheetView(saveHandler: viewModel as MealPlanEditorSheetView.MealPlanEditorSaveHandler,
                                    navigationPath: $navigationPath)
        }
        
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    } // END OF BODY
    
    
    
} // END OF STRUCT

//MARK: UI VARIABLES
extension MealPlanEditorView {
    
    var mealPlanSummarySection: some View {
        Section("Summary") {
            
            TextField("Meal plan name", text: $viewModel.mealPlanName)
                .textFieldStyle(.roundedBorder)
                .accessibilityIdentifier("meal-plan-title-textfield")
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
    }
    
    var addNewMealButton: some View {
        HStack {
            Spacer()
            Text("Add new meal")
            Spacer()
        }
        .onTapGesture {
            viewModel.addMeal()
        }
    }
}

//MARK: FUNCTIONS & VIEW BUILDERS
extension MealPlanEditorView {
    
    @ViewBuilder
    func generateMealSection(index: Int, meal: Meal) -> some View{
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
            HStack{
                Text("Meal #\(index + 1)")
                Spacer()
                Button {
                    viewModel.deleteMeal(meal)
                } label: {
                    Label("Delete meal", systemImage: "trash.circle.fill")
                        .foregroundColor(.red)
                }
            }
        } // END OF HEADER
        .headerProminence(.increased)
    }
    
    func generateIngredientLabel(ingredient: Ingredient) -> String {
        return ingredient.food.name + " " + String(ingredient.quantity) + " " + ingredient.unitOfMeasure
    }
    
    func generateRecipeLabel(recipe: Recipe) -> String {
        return recipe.name
    }
}

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
