//
//  IngredientPickerView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/14/23.
//

import SwiftUI
import Combine

struct IngredientPickerView<T: IngredientPickerViewModelProtocol>: View {
    
    @ObservedObject var viewModel: T
    let closure: (Ingredient) -> Void
    
    var body: some View {
        VStack {
            
            HStack {
                TextField("Type in ingredient name", text: $viewModel.searchTerm)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        viewModel.searchForIngredient()
                    }
                Button {
                    viewModel.searchForIngredient()
                } label: {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .font(.title)
                }
            }
            
            List {
                if !viewModel.ingredientsRow.isEmpty {
                    ForEach($viewModel.ingredientsRow, id: \.0.first?.id) { $tuple in
                        IngredientPickerRowView(ingredients: tuple.0, selectedIngredient: $tuple.1) { ingredient in
                            closure(ingredient)
                        } // END OF ROW
                    } // END OF FOREACH
                }
            }// END OF LIST
            .listStyle(.inset)
            .padding()
        }// END OF VSTACK
    } // END OF BODY
}

struct IngredientPickerView_Previews: PreviewProvider {
    class PreviewViewModel: IngredientPickerViewModelProtocol {
        @Published var ingredientsRow: [([Ingredient], Ingredient)] = []
        @Published var searchTerm: String = "Sample search text"
        
        func searchForIngredient() {
            let food = Food(name: "Sample food name")
            let nutritionForGram = Nutrition(calories: 10, carb: 1, fat: 1, protein: 1)
            let ingredient = Ingredient(food: food, quantity: 1, unitOfMeasure: "gram", nutritionData: nutritionForGram)
            let ingredient2 = Ingredient(food: food, quantity: 1, unitOfMeasure: "serving", nutritionData: nutritionForGram.multiplyBy(100))
            let ingredient3 = Ingredient(food: food, quantity: 1, unitOfMeasure: "kg", nutritionData: nutritionForGram.multiplyBy(1000))
            ingredientsRow = [([ingredient, ingredient2, ingredient3], ingredient)]
        }
    }
    static var previews: some View {
        IngredientPickerView(viewModel: PreviewViewModel()) { ingredient in
            print(ingredient.id)
        }
        
            .padding()
    }
}

