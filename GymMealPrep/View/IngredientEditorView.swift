//
//  IngredientEditorView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/3/23.
//

import SwiftUI

struct IngredientEditorView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var name: String
    @Binding var quantity: Double
    @Binding var unitOfMeasure: String
    @Binding var nutrition: Nutrition
    
    
    
    var body: some View {
        
        VStack {
            Text("Adding new ingredient")
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
                        TextField("Name", text: $name)
                            .textFieldStyle(.roundedBorder)
                    }
                    GridRow {
                        Text("Quantity")
                        TextField("quantity", value: $quantity, format: .number)
                            .textFieldStyle(.roundedBorder)
                    }
                    GridRow {
                        Text("Measurement")
                        TextField("Unit of measure", text: $unitOfMeasure)
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
                        TextField("cal", value: $nutrition.calories, format: .number)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    GridRow {
                        Text("Protein")
                        TextField("protein", value: $nutrition.protein, format: .number)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    GridRow {
                        Text("Fat")
                        TextField("fat", value: $nutrition.fat, format: .number)
                            .textFieldStyle(.roundedBorder)
                    }
                    GridRow {
                        Text("Carbs")
                        TextField("carbs", value: $nutrition.carb, format: .number)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    
                } // END OF NUTRITION GROUP
            }// END OF GRID
        
            .padding()
            .background(
                Color.gray.opacity(0.2))
            .cornerRadius(10)
            
            
            HStack {
                
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                
                
                Button("Save") {
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
        IngredientEditorView(name: .constant("Chicken breast"), quantity: .constant(2), unitOfMeasure: .constant("each"), nutrition: .constant(Nutrition(calories: 600.5, carb: 8, fat: 10, protein: 30)))
    }
}
