//
//  IngredientPickerRowView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/20/23.
//

import SwiftUI

struct IngredientPickerRowView: View {
    var ingredients: [Ingredient]
    @State var selectedIngredient: Int = 0
    let range: Range<Int>
    public init(ingredients: [Ingredient]) {
        self.ingredients = ingredients
        self.range = 0..<ingredients.count
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text(ingredients[selectedIngredient].food.name)
                    .font(.largeTitle)
                Spacer()
                Picker(selection: $selectedIngredient, label: Text("UOM picker")) {
                    
                    ForEach(range) { i in
                        Text(ingredients[i].unitOfMeasure).tag(i)
                        
                    }
                }
                .pickerStyle(.menu)
            }

            RecipeSummaryView(cal: ingredients[selectedIngredient].nutritionData.calories,
                                  proteinInGrams: ingredients[selectedIngredient].nutritionData.protein,
                                  fatInGrams: ingredients[selectedIngredient].nutritionData.fat,
                                  carbInGrams: ingredients[selectedIngredient].nutritionData.carb,
                                  format: "%.1f")
        }
    }
}

struct IngredientPickerRowView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientPickerRowView(ingredients: SampleData.sampleParsedIngredientRowData)
    }
}
