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
    @Published var ingredientQuantity = String() {
        didSet {
            if let newValue = filterStringToDouble(text: ingredientQuantity) {
                let oldQuantity = draftIngredient.quantity
                if lockNutritionValues {
                    draftIngredient.nutritionData = updateNutritionValues(newQty: newValue, oldQty: oldQuantity)
                }
                draftIngredient.quantity = newValue
            }
        }
    }
    @Published var ingredientCalories = String() {
        didSet {
            if let newValue = filterStringToFloat(text: ingredientCalories) {
                draftIngredient.nutritionData.calories = newValue
            }
        }
    }
    @Published var ingredientProtein = String() {
        didSet {
            if let newValue = filterStringToFloat(text: ingredientProtein) {
                draftIngredient.nutritionData.protein = newValue
            }
        }
    }
    @Published var ingredientFat = String() {
        didSet {
            if let newValue = filterStringToFloat(text: ingredientFat) {
                draftIngredient.nutritionData.fat = newValue
            }
        }
    }
    @Published var ingredientCarbs = String() {
        didSet {
            if let newValue = filterStringToFloat(text: ingredientCarbs) {
                draftIngredient.nutritionData.carb = newValue
            }
        }
    }
    
    init(ingredientToEdit: (any IngredientProtocol)?) {
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
        self.ingredientName = draftIngredient.food.name
        self.ingredientQuantity = String(draftIngredient.quantity)
        self.ingredientUnitOfMeasure = draftIngredient.unitOfMeasure
        self.ingredientCalories = String(draftIngredient.nutritionData.calories)
        self.ingredientProtein = String(draftIngredient.nutritionData.protein)
        self.ingredientFat = String(draftIngredient.nutritionData.fat)
        self.ingredientCarbs = String(draftIngredient.nutritionData.carb)
    }
}

//MARK: UPDATING INGREDIENT FUNCTIONS
extension IngredientEditorViewModel {
    func updateNutritionValues(newQty: Double, oldQty: Double) -> Nutrition {
        let factor: Double = newQty / oldQty
        let nutrition = draftIngredient.nutritionData.multiplyBy(factor)
        return nutrition
    }
}

//MARK: Helper function to translate String input to numeric values
extension IngredientEditorViewModel {
    
    func filterStringToDouble(text: String) -> Double? {
            let filtered = text
                            .replacingOccurrences(of: ",", with: ".")
                            .filter({ "0123456789.".contains($0) })
            return Double(filtered)
    }
    func filterStringToFloat(text: String) -> Float? {
            let filtered = text
                            .replacingOccurrences(of: ",", with: ".")
                            .filter({ "0123456789.".contains($0) })
            return Float(filtered)
    }
}
