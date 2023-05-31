//
//  IgredientHostView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/22/23.
//

import SwiftUI

struct IngredientHostView: View {
    
    @Environment(\.dismiss) var dismiss
    let title: String = "Add new ingredient"
    
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
            IngredientEditorView(viewModel: IngredientEditorViewModel()) { ingredientToSave in
                // assign ingredient to some value - this is a function already
                viewModel.addIngredient(ingredientToSave)
                DispatchQueue.main.async {
                    self.dismiss()
                }
            }
        }
        // a binding in sheet item can be a problem - should be able to extract to view?
        .sheet(item: $viewModel.selectedIngredient, content: { ingredientToEdit in
            IngredientEditorView(viewModel: IngredientEditorViewModel(ingredientToEdit: ingredientToEdit)) { ingredient in
                // assign ingredient to some value - this is a function already
                viewModel.addIngredient(ingredient)
                DispatchQueue.main.async {
                    self.dismiss()
                }
            }
            
        })
        .padding()
        .navigationTitle(title)
    }
}

struct IngredientHostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IngredientHostView(viewModel: RecipeViewModel(recipe: SampleData.recipieCilantroLimeChicken))
        }
    }
}
