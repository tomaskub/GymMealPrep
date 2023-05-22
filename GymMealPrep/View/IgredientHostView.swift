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
            IngredientPickerView()
            { ingredient in
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
                viewModel.addIngredient(ingredientToSave)
                DispatchQueue.main.async {
                    self.dismiss()
                }
            }
        }
        .sheet(item: $viewModel.selectedIngredient, content: { ingredientToEdit in
            IngredientEditorView(editedIngredient: ingredientToEdit) { ingredient in viewModel.addIngredient(ingredient)
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
