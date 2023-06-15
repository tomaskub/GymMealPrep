//
//  RecipeCreatorView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/27/23.
//

import SwiftUI

struct RecipeCreatorView: View {
    
    @ObservedObject var viewModel: RecipeCreatorViewModelProtocol
    
    var body: some View {
        VStack(alignment: .leading) {
            
            TextField("Recipe titile", text: $viewModel.recipeTitle)
                .font(.title3)
                .fontWeight(.semibold)
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(20)
            
            HStack {
                Text("Ingredients:")
                    .fontWeight(.semibold)
                    .font(.title3)
                Spacer()
                Stepper("\(viewModel.servings) \(stepperLabel)", value: $viewModel.servings)
                    .fixedSize()
            }
            
            TextEditor(text: $viewModel.ingredientsEntry)
                .scrollContentBackground(.hidden)
                .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                .background(.gray.opacity(0.1))
                .cornerRadius(20)
            
            Text("Instructions:")
                .fontWeight(.semibold)
                .font(.title3)
            
            TextEditor(text: $viewModel.instructionsEntry)
                .scrollContentBackground(.hidden)
                .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                .background(.gray.opacity(0.1))
                .cornerRadius(20)
        } // END OF VSTACK
        .padding()
        .navigationTitle("Create recipe")
    } // END OF BODY
    var stepperLabel: String {
        viewModel.servings > 1 ? "servings" : "serving"
    }
} // END OF STRUCT


struct RecipeCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeCreatorView(viewModel: RecipeCreatorViewModel())
        }
    }
}
