//
//  IngredientPickerView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/14/23.
//

import SwiftUI
import Combine

struct IngredientPickerView: View {
    @StateObject var viewModel = IngredientPickerViewModel()
    
    var body: some View {
        VStack {
            
            HStack {
                TextField("Type in ingredient name", text: $viewModel.searchTerm)
                    .textFieldStyle(.roundedBorder)
                Button {
                    viewModel.searchForIngredient()
                } label: {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .font(.title)
                }
            }
            
            List {
                ForEach(viewModel.ingredients) { ingredient in
                    VStack {
                        HStack {
                            Text(ingredient.food.name)
                            Text(String(format: "%.2d" , ingredient.quantity))
                            Text(ingredient.unitOfMeasure)
                        }
                        HStack {
                            RecipeSummaryView(
                                cal: ingredient.nutritionData.calories,
                                proteinInGrams: ingredient.nutritionData.protein,
                                fatInGrams: ingredient.nutritionData.fat,
                                carbInGrams: ingredient.nutritionData.carb, format: "%.0f")
                        }
                        
                    }
                }
            }
            .listStyle(.inset)
        }
        .padding()
    }
}

struct IngredientPickerView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientPickerView()
    }
}

