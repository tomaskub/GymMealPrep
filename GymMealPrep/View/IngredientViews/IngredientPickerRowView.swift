//
//  IngredientPickerRowView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/20/23.
//

import SwiftUI

struct IngredientPickerRowView: View {
    
    //MARK: INITIALIZED PROPERTIES
    var ingredients: [Ingredient]
    @Binding var selectedIngredient: Ingredient
    let buttonAction: (Ingredient) -> Void
    
    //MARK: OWNED PROPERTIES
    @State var selectedIngredientID: Ingredient.ID
    let format: String = "%.1f"
    
    public init(ingredients: [Ingredient], selectedIngredient: Binding<Ingredient>, buttonAction: @escaping (Ingredient) -> Void) {
        self.ingredients = ingredients
        self._selectedIngredient = selectedIngredient
        self.buttonAction = buttonAction
        self._selectedIngredientID = State(initialValue: ingredients.first?.id ?? UUID())
    }
    
    var body: some View {
        HStack {
            Grid {
                
                GridRow {
                    Text(ingredients[0].food.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .gridCellColumns(4)
                }// END OF GRID ROW
                
                GridRow {
                    ForEach(buildNutrientsLabel(), id: \.0) { data in
                        VStack {
                            Text(data.0)
                            Text(data.1)
                                .lineLimit(1)
                                .allowsTightening(true)
                        }
                    } // END OF FOREACH
                } // END OF GRID ROW
            }// END OF GRID
            
            Spacer(minLength: 0)
                
            VStack {
                
                Picker("Did", selection: $selectedIngredientID) {
                    ForEach(ingredients) { ingredient in
                        Text(ingredient.unitOfMeasure).tag(ingredient.id)
                    }
                }
                .labelsHidden()
                .pickerStyle(.menu)
                .onChange(of: $selectedIngredientID.wrappedValue, perform: setIngredient)
                
                Button {
                    buttonAction(selectedIngredient)
                } label: {
                    Text("Add")
                }
                .buttonStyle(.borderedProminent)
            }// END OF VSTAKC
        } // END OF HSTACK
    } // END OF BODY
    
    private func setIngredient(id: Ingredient.ID) {
        if let ingredient = ingredients.first(where: { $0.id == selectedIngredientID }) {
            selectedIngredient = ingredient
        }
    }
    
    private func buildNutrientsLabel() -> [(String, String)] {
        return [("Cal", String(format: format, selectedIngredient.nutritionData.calories)),
                ("Pro", String(format: format, selectedIngredient.nutritionData.protein)),
                ("Fat", String(format: format, selectedIngredient.nutritionData.fat)),
                ("Car", String(format: format, selectedIngredient.nutritionData.carb)),]
    }
}

struct IngredientPickerRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            IngredientPickerRowView(ingredients: SampleData.sampleParsedIngredientRowData, selectedIngredient: .constant(SampleData.sampleParsedIngredientRowData[0])){ ing in
                print("Added")
            }
        }
        .padding()
        .listStyle(.inset)
        
    }
}
