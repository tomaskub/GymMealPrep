//
//  RecipeCreatorParserView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/28/23.
//

import SwiftUI

struct RecipeCreatorParserView: View {
    
    @ObservedObject var viewModel: RecipeCreatorViewModelProtocol
    var saveHandler: IngredientSaveHandler
    
    var body: some View {
        VStack {
            
            List {
                
                Section {
                    ForEach(viewModel.ingredientsNLArray, id: \.self) { input in
                        NavigationLink {
                            if let parsedIngredients = viewModel.parsedIngredients[input] {
                                
                                IngredientHostView(
                                    title: "Change match",
                                    buttonTitle: "Change manually",
                                    saveHandler: saveHandler,
                                    pickerViewModel:
                                        IngredientPickerViewModel(
                                            ingredients: parsedIngredients,
                                            searchTerm: input))
                                
                            } else {
                            
                                IngredientHostView(
                                    title: "Correct match",
                                    buttonTitle: "Add manually",
                                    saveHandler: saveHandler,
                                    pickerViewModel:
                                        IngredientPickerViewModel(
                                            ingredients: [[]],
                                            searchTerm: input))
                            }
                        } label: {
                            
                            VStack(alignment: .leading) {
                                Text(input.lowercased())
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.top)
                                if let parsedIngredient = viewModel.matchedIngredients[input] {
                                    HStack {
                                        Text(String(format: "%.2f", parsedIngredient.quantity))
                                        Text(parsedIngredient.unitOfMeasure)
                                        Text(parsedIngredient.food.name)
                                    }
                                    NutritionStripeView(nutrition: parsedIngredient.nutritionData)
                                } else {
                                    Text("We failed to find the ingredient, tap to search for ingredient manually")
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.blue)
                                } // END OF IF-ELSE
                            } // END OF VSTACK
                        } // END OF NAV LINK
                    } // END OF FOR EACH
                } header: {
                    Text("\(viewModel.parsedIngredients.count) Ingredients:")
                        .font(.title2)
                        .foregroundColor(.blue)
                } // END OF SECTION
            } // END OF LIST
        } // END OF VSTACK
        
        .listStyle(.inset)
        .navigationTitle("Match ingredients")
        .navigationBarTitleDisplayMode(.inline)
        
    } // END OF BODY
} // END OF STRUCT

struct RecipeCreatorParserView_Previews: PreviewProvider {
    
    class PreviewViewModel: RecipeCreatorViewModelProtocol {
        
        override init() {
            super.init()
            self.ingredientsNLArray = ["1 cup of rice", "1 chicken breast", "2 cups of broccoli florets", "This ingredient failed to parse"]
            self.parsedIngredients = [
                "1 cup of rice" : [[Ingredient(food: Food(name: "Rice"), quantity: 1, unitOfMeasure: "Cup", nutritionData: Nutrition.zero),Ingredient(food: Food(name: "Rice"), quantity: 1, unitOfMeasure: "kg", nutritionData: Nutrition.zero)]],
                "1 chicken breast" : [[Ingredient(food: Food(name: "Chicken breast"), quantity: 1, unitOfMeasure: "Piece", nutritionData: Nutrition.zero)]],
                "2 cups of broccoli florets" : [[Ingredient(food: Food(name: "Broccoli"), quantity: 2, unitOfMeasure: "Cup", nutritionData: Nutrition.zero)]]]
                self.matchedIngredients = [
                    "1 cup of rice" : Ingredient(food: Food(name: "Rice"), quantity: 1, unitOfMeasure: "Cup", nutritionData: Nutrition.zero),
                    "1 chicken breast" : Ingredient(food: Food(name: "Chicken breast"), quantity: 1, unitOfMeasure: "Piece", nutritionData: Nutrition.zero),
                    "2 cups of broccoli florets" : Ingredient(food: Food(name: "Broccoli"), quantity: 2, unitOfMeasure: "Cup", nutritionData: Nutrition.zero)
                                          ]
            
        } // END OF INIT
        
        override func processInput() {
            print("Processing input called")
        }
    } // END OF CLASS
    
    class PreviewSaveHandler: IngredientSaveHandler {
        
        
        func addIngredient(_: Ingredient, _: String?) {
            // do nothing
        }
        
        
    }
    static var previews: some View {
        NavigationStack {
            RecipeCreatorParserView(viewModel: PreviewViewModel(), saveHandler: PreviewSaveHandler())
        }
    }
}
