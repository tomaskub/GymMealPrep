//
//  IngredientEditorViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/23/23.
//

import Foundation

class IngredientEditorViewModel: ObservableObject {
    
    //MARK: VIEW STATE PROPERITES
    @Published var lockNutritionValues: Bool
    @Published var isEditingIngredient: Bool
    
    //MARK: DRAFT INGREDIENT PROPERTY
    @Published var draftIngredient: any IngredientProtocol
    
    //MARK: VIEW TEXTFIELDS PROPERTIES
    //Initialized here so they can be overriden in init using draftIngredient values
    @Published var ingredientName = String()
    @Published var ingredientUnitOfMeasure = String()
    
    //Strings representing numeric values
    @Published var ingredientQuantity = String()
    @Published var ingredientCalories = String()
    @Published var ingredientProtein = String()
    @Published var ingredientFat = String()
    @Published var ingredientCarbs = String()
    
    init(ingredientToEdit: (any IngredientProtocol)? = nil) {
        //unwrap and configure view state based on wheter the ingredient was passed in
        if let ingredient = ingredientToEdit {
            self.draftIngredient = ingredient
            self.lockNutritionValues = true
            self.isEditingIngredient = true
        } else {
            self.draftIngredient = Ingredient() // TODO: this is concrete so i have to check how to set it to the same type - should it be generic protocol?
            self.lockNutritionValues = false
            self.isEditingIngredient = false
        }
        // override field texts properties
        if self.isEditingIngredient {
            updatePublishedValues()
        }
    }
    
}


//MARK: UPDATING INGREDIENT FUNCTIONS
extension IngredientEditorViewModel {
    
    func updateIngredient() {
        draftIngredient.food.name = ingredientName
        draftIngredient.unitOfMeasure = ingredientUnitOfMeasure
        
        if lockNutritionValues {
            let oldQty = draftIngredient.quantity
            let newQty = Double(ingredientQuantity) ?? 0
            draftIngredient.nutritionData = updateNutritionValues(newQty: newQty, oldQty: oldQty)
            draftIngredient.quantity = newQty
        } else {
            draftIngredient.quantity = Double(ingredientQuantity) ?? 0
            draftIngredient.nutritionData.protein = Float(ingredientProtein) ?? 0
            draftIngredient.nutritionData.calories = Float(ingredientCalories) ?? 0
            draftIngredient.nutritionData.fat = Float(ingredientFat) ?? 0
            draftIngredient.nutritionData.carb = Float(ingredientCarbs) ?? 0
        }
        updatePublishedValues()
    }
    
    func updatePublishedValues() {
        ingredientName = draftIngredient.food.name
        ingredientQuantity = draftIngredient.quantity == 0 ? String() : String(draftIngredient.quantity)
        ingredientUnitOfMeasure = draftIngredient.unitOfMeasure
        ingredientCalories = draftIngredient.nutritionData.calories == 0 ? String(): String(draftIngredient.nutritionData.calories)
        ingredientProtein = draftIngredient.nutritionData.protein == 0 ? String() : String(draftIngredient.nutritionData.protein)
        ingredientFat = draftIngredient.nutritionData.fat == 0 ? String() : String(draftIngredient.nutritionData.fat)
        ingredientCarbs = draftIngredient.nutritionData.carb == 0 ? String() : String(draftIngredient.nutritionData.carb)
    }
    
    func updateNutritionValues(newQty: Double, oldQty: Double) -> any NutritionProtocol {
        guard oldQty != 0 else { return draftIngredient.nutritionData }
        let factor: Double = newQty / oldQty
        let nutrition = draftIngredient.nutritionData.multiplyBy(factor)
        return nutrition
    }
}
