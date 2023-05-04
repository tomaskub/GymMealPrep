//
//  IngredientEditorView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/3/23.
//

import SwiftUI

struct IngredientEditorView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var editedIngredient: Ingredient?
    @State private var draftIngredient: Ingredient = Ingredient()
    
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
                    editedIngredient = draftIngredient
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            Spacer()
            
        }// END OF VSTACK
        .padding()
        .onAppear {
            if let ingredient = editedIngredient {
                draftIngredient = ingredient
            }
        }
    }
        
}

struct IngredientEditorView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientEditorView(editedIngredient: .constant(nil))
    }
}
