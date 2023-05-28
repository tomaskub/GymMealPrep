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
                    VStack(alignment: .leading) {
                        
                        Text(response.0.lowercased())
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top)
                        
                        if let parsedIngredient = response.1.first?.first {
                            HStack {
                                Text(String(format: "%.2f", parsedIngredient.quantity))
                                Text(parsedIngredient.unitOfMeasure)
                                Text(parsedIngredient.food.name)
                            }
                            NutritionStripe(nutrition: parsedIngredient.nutritionData)
                        } else {
                            Text("We failed to find the ingredient, tap to search for ingredient manually")
                                .foregroundColor(.blue)
                        } // END OF IF-ELSE
                    } // END OF VSTACK
                } // END OF FOR EACH
            } header: {
                Text("\(viewModel.parsedIngredients.count) Ingredients:")
                    .font(.title2)
                    .foregroundColor(.blue)
            } // END OF SECTION
        } // END OF LIST
        .listStyle(.inset)
        .onAppear {
            viewModel.processInput()
        } // END OF ON APPEAR
        .navigationTitle("Create recipe")
        
    } // END OF BODY
    
    private struct NutritionStripe: View {
        
        let nutrition: any NutritionProtocol
        
        var body: some View {
            HStack {
                Text("Calories")
                    .foregroundColor(.gray)
                Text(String(nutrition.calories))
                Text("Fat")
                    .foregroundColor(.gray)
                Text(String(nutrition.fat))
                Text("Carbs")
                    .foregroundColor(.gray)
                Text(String(nutrition.carb))
                Text("Protein")
                    .foregroundColor(.gray)
                Text(String(nutrition.calories))
            }
            .font(.caption)
        }
    } //END OF NUTRITION STRIPE VIEW
} // END OF STRUCT

struct RecipeCreatorParserView_Previews: PreviewProvider {
    
    class PreviewViewModel: RecipeCreatorViewModelProtocol {
        
        override init() {
            super.init()
            self.parsedIngredients = [
                ("1 cup of rice", [[Ingredient(food: Food(name: "Rice"), quantity: 1, unitOfMeasure: "Cup", nutritionData: Nutrition.zero)]]),
            ("1 chicken breast", [[Ingredient(food: Food(name: "Chicken breast"), quantity: 1, unitOfMeasure: "Piece", nutritionData: Nutrition.zero)]]),
                ("2 cups of broccoli florets", [[Ingredient(food: Food(name: "Broccoli"), quantity: 2, unitOfMeasure: "Cup", nutritionData: Nutrition.zero)]])
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
