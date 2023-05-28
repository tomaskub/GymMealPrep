//
//  RecipeCreatorParserView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/28/23.
//

import SwiftUI

struct RecipeCreatorParserView: View {
    
    @ObservedObject var viewModel: RecipeCreatorViewModelProtocol
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.parsedIngredients, id: \.self.0) { response in
                    // TODO: IMPLEMENT UI
                    VStack(alignment: .leading) {
                        Text(response.0.lowercased())
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top)
                        HStack {
                            Text(String(format: "%.2f", response.1.first?.quantity ?? 0))
                            Text(response.1.first?.unitOfMeasure ?? "UOM")
                            Text(response.1.first?.food.name ?? "Error")
                        }
                        HStack {
                            Text("Calories")
                                .foregroundColor(.gray)
                            Text(String(response.1.first?.nutritionData.calories ?? 0))
                            Text("Fat")
                                .foregroundColor(.gray)
                            Text(String(response.1.first?.nutritionData.fat ?? 0))
                            Text("Carbs")
                                .foregroundColor(.gray)
                            Text(String(response.1.first?.nutritionData.carb ?? 0))
                            Text("Protein")
                                .foregroundColor(.gray)
                            Text(String(response.1.first?.nutritionData.calories ?? 0))
                        }
                        .font(.caption)
                        
                    }
                    
                } // END OF FOR EACH
            } header: {
                Text("\(viewModel.parsedIngredients.count) Ingredients:")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
        } // END OF LIST
        .listStyle(.inset)
        .onAppear {
            viewModel.processInput()
        } // END OF ON APPEAR
        .navigationTitle("Create recipe")
    } // END OF BODY
} // END OF STRUCT

struct RecipeCreatorParserView_Previews: PreviewProvider {
    
    class PreviewViewModel: RecipeCreatorViewModelProtocol {
        
        override init() {
            super.init()
            self.parsedIngredients = [
                ("1 cup of rice", [Ingredient(food: Food(name: "Rice"), quantity: 1, unitOfMeasure: "Cup", nutritionData: Nutrition.zero)]),
            ("1 chicken breast", [Ingredient(food: Food(name: "Chicken breast"), quantity: 1, unitOfMeasure: "Piece", nutritionData: Nutrition.zero)]),
                ("2 cups of broccoli florets", [Ingredient(food: Food(name: "Broccoli"), quantity: 2, unitOfMeasure: "Cup", nutritionData: Nutrition.zero)])
            ]
        } // END OF INIT
        
        override func processInput() {
            print("Processing input call")
        }
    } // END OF CLASS
    static var previews: some View {
        NavigationView {
            RecipeCreatorParserView(viewModel: PreviewViewModel())
        }
    }
}
