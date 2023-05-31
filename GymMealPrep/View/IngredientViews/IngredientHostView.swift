//
//  IgredientHostView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/22/23.
//

import SwiftUI

protocol IngredientSaveHandler {
    func addIngredient(_:Ingredient)
}

struct IngredientHostView: View {
    
    @Environment(\.dismiss) var dismiss
    let title: String = "Add new ingredient"
    
    var saveHandler: IngredientSaveHandler
    @StateObject var pickerViewModel: IngredientPickerViewModel
    
    @State var addNewIngredient: Bool = false
    @State var selectedIngredient: Ingredient? = nil
    
    var body: some View {
        VStack {
            IngredientPickerView(viewModel: pickerViewModel)
            { ingredient in
                // assign ingredient to some value - can be a function
                selectedIngredient = ingredient
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
                saveHandler.addIngredient(ingredientToSave)
                DispatchQueue.main.async {
                    self.dismiss()
                }
            }
        }
        .sheet(item: $selectedIngredient, content: { ingredientToEdit in
            IngredientEditorView(viewModel: IngredientEditorViewModel(ingredientToEdit: ingredientToEdit)) { ingredientToSave in
                saveHandler.addIngredient(ingredientToSave)
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
            IngredientHostView(saveHandler: RecipeViewModel(recipe: SampleData.recipieCilantroLimeChicken), pickerViewModel: IngredientPickerViewModel())
        }
    }
}
