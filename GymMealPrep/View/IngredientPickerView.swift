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
                            print("Added ingredient: \(ingredient.food.name) - \(ingredient.quantity) \(ingredient.unitOfMeasure)")
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
    static var previews: some View {
        IngredientPickerView().padding()
    }
}

