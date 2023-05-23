//
//  IngredientEditorViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/23/23.
//

import Foundation

class IngredientEditorViewModel: ObservableObject {
    
    @Published var lockNutritionValues: Bool
    @Published var isEditingIngredient: Bool
    @Published var draftIngredient: Ingredient
    
    
    
    //MARK: View textFields properties
    //Initialized here so they can be overriden in init using draftIngredient values
    @Published var ingredientName = String()
    @Published var ingredientQuantity = String()
    @Published var ingredientUnitOfMeasure = String()
    @Published var ingredientCalories = String()
    @Published var ingredientProtein = String()
    @Published var ingredientFat = String()
    @Published var ingredientCarbs = String()
    
    init(ingredientToEdit: Ingredient?) {
        //unwrap and configure view state based on wheter the ingredient was passed in
        if let ingredient = ingredientToEdit {
            self.draftIngredient = ingredient
            self.lockNutritionValues = true
            self.isEditingIngredient = true
        } else {
            self.draftIngredient = Ingredient()
            self.lockNutritionValues = false
            self.isEditingIngredient = false
        }
        // override field texts properties
        self.ingredientName = draftIngredient.food.name
        self.ingredientQuantity = String(draftIngredient.quantity)
        self.ingredientUnitOfMeasure = draftIngredient.unitOfMeasure
        self.ingredientCalories = String(draftIngredient.nutritionData.calories)
        self.ingredientProtein = String(draftIngredient.nutritionData.protein)
        self.ingredientFat = String(draftIngredient.nutritionData.fat)
        self.ingredientCarbs = String(draftIngredient.nutritionData.carb)
    }
}
