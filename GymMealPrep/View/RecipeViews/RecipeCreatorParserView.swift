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
        VStack {
            
            Text("Ingredients:")
                .font(.title)
            
            ForEach(viewModel.parsedIngredients, id: \.self.0) { response in
                // TODO: IMPLEMENT UI
                Text(response.1.first?.food.name ?? "Error")
            } // END OF FOR EACH
        } // END OF VSTACK
        .onAppear {
            viewModel.processInput()
        } // END OF ON APPEAR
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
        RecipeCreatorParserView(viewModel: PreviewViewModel())
    }
}
