//
//  IngredientEditorView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/3/23.
//

import SwiftUI

struct IngredientEditorView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var lockNutritionValues: Bool = false
    @State private var draftIngredient: Ingredient = Ingredient()
    
    var editedIngredient: Ingredient?
    let saveAction: (Ingredient) -> Void
    
    var body: some View {
        
        VStack {
            Text(editedIngredient != nil ? "Edit ingredient" :"Adding new ingredient")
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
                        TextField("Name", text: $draftIngredient.food.name)
                            .textFieldStyle(.roundedBorder)
                    }
                    GridRow {
                        Text("Quantity")
                        TextField("quantity", value: $draftIngredient.quantity, format: .number)
                            .textFieldStyle(.roundedBorder)
                    }
                    GridRow {
                        Text("Measurement")
                        TextField("Unit of measure", text: $draftIngredient.unitOfMeasure)
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
                        TextField("cal", value: $draftIngredient.nutritionData.calories, format: .number)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    GridRow {
                        Text("Protein")
                        TextField("protein", value: $draftIngredient.nutritionData.protein, format: .number)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    GridRow {
                        Text("Fat")
                        TextField("fat", value: $draftIngredient.nutritionData.fat, format: .number)
                            .textFieldStyle(.roundedBorder)
                    }
                    GridRow {
                        Text("Carbs")
                        TextField("carbs", value: $draftIngredient.nutritionData.carb, format: .number)
                            .textFieldStyle(.roundedBorder)
                    }
                } // END OF NUTRITION GROUP
                .disabled(lockNutritionValues)
                
                        Toggle("Lock nutrition values", isOn: $lockNutritionValues)
                        .tint(.blue)
                    .gridCellColumns(2)
                    
                
            }// END OF GRID
        
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
                    saveAction(draftIngredient)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            Spacer()
            
        }// END OF VSTACK
        .padding()
    }
        
}

struct IngredientEditorView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientEditorView(editedIngredient: nil, saveAction: { _ in })
    }
}
