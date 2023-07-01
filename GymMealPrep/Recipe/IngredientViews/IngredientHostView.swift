//
//  IgredientHostView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/22/23.
//

import SwiftUI

protocol IngredientSaveHandler {
    func addIngredient(_: Ingredient, _: String?)
}

struct IngredientHostView: View {

    @Environment(\.dismiss) var dismiss
    
    let title: String
    let buttonTitle: String
    
    var saveHandler: IngredientSaveHandler
    
    @StateObject var pickerViewModel: IngredientPickerViewModel
    @State private var addNewIngredient: Bool = false
    @State private var selectedIngredient: Ingredient? = nil
    
    var body: some View {
        VStack {
            IngredientPickerView(viewModel: pickerViewModel)
            { ingredient in
                selectedIngredient = ingredient
            }
            Spacer()
            Button(buttonTitle) {
                addNewIngredient.toggle()
            }
            .buttonStyle(.borderedProminent)
        }
        .sheet(isPresented: $addNewIngredient) {
            IngredientEditorView(viewModel: IngredientEditorViewModel()) { ingredientToSave in
                // assign ingredient to some value - this is a function already
                saveHandler.addIngredient(ingredientToSave, pickerViewModel.originalSearchTerm)
                DispatchQueue.main.async {
                    self.dismiss()
                }
            }
        }
        .sheet(item: $selectedIngredient, content: { ingredientToEdit in
            IngredientEditorView(viewModel: IngredientEditorViewModel(ingredientToEdit: ingredientToEdit)) { ingredientToSave in
                saveHandler.addIngredient(ingredientToSave, pickerViewModel.originalSearchTerm)
                DispatchQueue.main.async {
                    self.dismiss()
                }
            }
            
        })
        .navigationTitle(title)
    }
}

struct IngredientHostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IngredientHostView(title: "Add new ingredient", buttonTitle: "Add manually",
                saveHandler: RecipeViewModel(recipe: SampleData.recipieCilantroLimeChicken),
                pickerViewModel: IngredientPickerViewModel())
        }
    }
}
