//
//  IgredientHostView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/22/23.
//

import SwiftUI

struct IgredientHostView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: RecipeViewModel
    
    @State var addNewIngredient: Bool = false
     
    var body: some View {
        VStack {
            IngredientPickerView(viewModel: IngredientPickerViewModel())
            { ingredient in
                // assign ingredient to some value - can be a function
                viewModel.selectedIngredient = ingredient
            }
            Spacer()
            Button("Add manually") {
                addNewIngredient.toggle()
            }
            .buttonStyle(.borderedProminent)
        }
        .sheet(isPresented: $addNewIngredient) {
            IngredientEditorView { ingredientToSave in
                // assign ingredient to some value - this is a function already
                viewModel.addIngredient(ingredientToSave)
                DispatchQueue.main.async {
                    self.dismiss()
                }
            }
        }
        // a binding in sheet item can be a problem - should be able to extract to view?
        .sheet(item: $viewModel.selectedIngredient, content: { ingredientToEdit in
            IngredientEditorView(editedIngredient: ingredientToEdit) { ingredient in
                // assign ingredient to some value - this is a function already
                viewModel.addIngredient(ingredient)
                DispatchQueue.main.async {
                    self.dismiss()
                }
            }
            
        })
        .padding()
        .navigationTitle("Add new ingredient")
    }
}

struct IgredientHostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IgredientHostView(viewModel: RecipeViewModel(recipe: SampleData.recipieCilantroLimeChicken))
        }
    }
}
