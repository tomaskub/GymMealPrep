//
//  MealPlanViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/29/23.
//

import Foundation

protocol MealPlanViewModelProtocol: ObservableObject, RecipeSaveHandler, IngredientSaveHandler {
    var mealPlan: MealPlan { get }
    var mealPlanName: String { get set }
    var selectedMeal: Meal? { get set }
    
    func removeFromMeal(meal: Meal, _: Ingredient)
    
    func removeFromMeal(meal: Meal, _: Recipe)
    
    func addRecipe(_: Recipe)
    
    func addIngredient(_: Ingredient, _: String?)
    
    func addMeal()
}

class MealPlanViewModel: MealPlanViewModelProtocol {
    
    @Published var selectedMeal: Meal?
    @Published var mealPlanName: String
    @Published var mealPlan: MealPlan
    private var dataManager: MealPlanDataManagerProtocol
    
    init(mealPlan: MealPlan, dataManager: MealPlanDataManagerProtocol = DataManager.shared as MealPlanDataManagerProtocol) {
        self.mealPlan = mealPlan
        self.dataManager = dataManager
        if let name = mealPlan.name {
            self.mealPlanName = name
        } else {
            self.mealPlanName = String()
        }
    }
    
    func removeFromMeal(meal: Meal, _ ingredientToRemove: Ingredient) {
        guard let index = mealPlan.meals.firstIndex(of: meal) else { return }
        mealPlan.meals[index].ingredients.removeAll(where: { $0.id == ingredientToRemove.id })
    }
    
    func removeFromMeal(meal: Meal, _ recipeToRemove: Recipe) {
        guard let index = mealPlan.meals.firstIndex(of: meal) else { return }
        mealPlan.meals[index].ingredients.removeAll(where: { $0.id == recipeToRemove.id })
    }
    
    func addRecipe(_ recipeToAdd: Recipe) {
        guard let meal = selectedMeal, let index = mealPlan.meals.firstIndex(of: meal) else {
            print("Failure in adding a recipe to meal")
            return
        }
        mealPlan.meals[index].recipes.append(recipeToAdd)
    }
    
    func addIngredient(_ ingredientToAdd: Ingredient, _: String?) {
        guard let meal = selectedMeal, let index = mealPlan.meals.firstIndex(where: { $0.id == meal.id }) else {
            print("Failure in ")
            return
        }
        mealPlan.meals[index].ingredients.append(ingredientToAdd)
    }
    
    func addMeal() {
        mealPlan.meals.append(Meal())
    }
    
    func saveChanges() {
        updateMealPlan()
        dataManager.updateAndSave(mealPlan: mealPlan)
    }
    
    func updateMealPlan() {
        mealPlan.name = mealPlanName
    }
}
