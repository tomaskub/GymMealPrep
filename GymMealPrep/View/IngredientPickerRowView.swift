//
//  IngredientPickerRowView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/20/23.
//

import SwiftUI

struct IngredientPickerRowView: View {
    var ingredients: [Ingredient]
    @State var selectedIngredient: Ingredient
    
    public init(ingredients: [Ingredient]) {
        self.ingredients = ingredients
        self._selectedIngredient = State(initialValue: ingredients.first!)
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text(ingredients[0].food.name)
                    .font(.largeTitle)
                Spacer()
                Picker(String(), selection: $selectedIngredient) {
                    ForEach(ingredients) { ingredient in
                        Text(ingredient.unitOfMeasure).tag(ingredient)
                    }
                }
                .pickerStyle(.menu)
                
            }

            RecipeSummaryView(cal: selectedIngredient.nutritionData.calories,
                                  proteinInGrams: selectedIngredient.nutritionData.protein,
                                  fatInGrams: selectedIngredient.nutritionData.fat,
                                  carbInGrams: selectedIngredient.nutritionData.carb,
                                  format: "%.1f")
        }
    }
}

struct IngredientPickerRowView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientPickerRowView(ingredients: SampleData.sampleParsedIngredientRowData)
    }
}
