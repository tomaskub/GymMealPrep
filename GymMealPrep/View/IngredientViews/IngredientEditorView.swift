//
//  IngredientEditorView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/3/23.
//

import SwiftUI

struct IngredientEditorView: View {
    
    @Environment(\.dismiss) var dismiss

    @StateObject private var viewModel: IngredientEditorViewModel
    let saveAction: (Ingredient) -> Void
    
    init(editedIngredient: (any IngredientProtocol)? = nil, saveAction: @escaping (Ingredient) -> Void) {
        self._viewModel = StateObject(wrappedValue:  IngredientEditorViewModel(ingredientToEdit: editedIngredient))
        self.saveAction = saveAction
    }
    
    var body: some View {
        
        VStack {
            Text(titileText)
                .font(.title)
                .padding(.bottom)
            
            Grid(alignment: .centerFirstTextBaseline) {
                Group {
                    Text("Ingredient:")
                        .font(.title2)
                    
                    Divider()
                        .background(.white)
                    
                    GridRow{
                        Text("Name")
                        TextField("Name", text: $viewModel.ingredientName)
                            .textFieldStyle(.roundedBorder)
                    }
                    GridRow {
                        Text("Quantity")
                        TextField("quantity", text: $viewModel.ingredientQuantity)
                            .numericalInputOnly($viewModel.ingredientQuantity, includeDecimal: true)
                            .textFieldStyle(.roundedBorder)
                    }
                    GridRow {
                        Text("Measurement")
                        TextField("Unit of measure", text: $viewModel.ingredientUnitOfMeasure)
                            .textFieldStyle(.roundedBorder)
                    }
                } // END OF INGREDIENT GROUP
                
                Group {
                    Text("Nutrition:")
                        .font(.title2)
                    
                    Divider()
                        .background(.white)
                    
                    GridRow{
                        Text("Calories")
                        TextField("kcal", text: $viewModel.ingredientCalories)
                            .numericalInputOnly($viewModel.ingredientCalories, includeDecimal: true)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    GridRow {
                        Text("Protein")
                        TextField("grams", text: $viewModel.ingredientProtein)
                            .numericalInputOnly($viewModel.ingredientProtein, includeDecimal: true)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    GridRow {
                        Text("Fat")
                        TextField("grams", text: $viewModel.ingredientFat)
                            .numericalInputOnly($viewModel.ingredientFat, includeDecimal: true)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    GridRow {
                        Text("Carbs")
                        TextField("grams", text: $viewModel.ingredientCarbs)
                            .numericalInputOnly($viewModel.ingredientCarbs, includeDecimal: true)
                            .textFieldStyle(.roundedBorder)
                            
                    }
                } // END OF NUTRITION GROUP
                .disabled(viewModel.lockNutritionValues)
                
                Toggle("Lock nutrition values", isOn: $viewModel.lockNutritionValues)
                        .tint(.blue)
                    .gridCellColumns(2)
                    
                
            }// END OF GRID
            .onSubmit {
                viewModel.updateIngredient()
            }
            
            .padding()
            .background(
                Color.gray.opacity(0.2))
            .cornerRadius(10)
            
            
            HStack(spacing: 20) {
                
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Save") {
                    viewModel.updateIngredient()
                    saveAction(viewModel.draftIngredient as! Ingredient)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            Spacer()
            
        }// END OF VSTACK
        .padding()
    }
    
    var titileText: String {
        viewModel.isEditingIngredient ? "Edit ingredient" : "Adding new ingredient"
    }
}

struct IngredientEditorView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientEditorView(editedIngredient: nil, saveAction: { ingredient in
            print(ingredient)
        })
    }
}
