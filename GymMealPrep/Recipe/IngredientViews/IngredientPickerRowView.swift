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
    let rowTapAction: (Ingredient) -> Void
    
    //MARK: OWNED PROPERTIES
    @State private var selectedIngredientID: Ingredient.ID
    @State private var pickerWidth = CGFloat.zero
    
    public init(ingredients: [Ingredient], selectedIngredient: Binding<Ingredient>, rowTapAction: @escaping (Ingredient) -> Void) {
        self.ingredients = ingredients
        self._selectedIngredient = selectedIngredient
        self.rowTapAction = rowTapAction
        self._selectedIngredientID = State(initialValue: ingredients.first?.id ?? UUID())
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading) {
                    HStack {
                        
                        Text(ingredients[0].food.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.vertical, 4)
                        
                        Spacer(minLength:0)
                        
                        //reserve space for picker in next layer
                        Color.clear
                            .frame(width: pickerWidth, height: 1)
                            .border(.blue)
                        
                    }// END OF HSTACK
                    
                    NutritionStripeView(nutrition: selectedIngredient.nutritionData)
                    
                } // END OF VSTACK
                .contentShape(Rectangle())
                .onTapGesture {
                    rowTapAction(selectedIngredient)
                }
            
            Picker("Did", selection: $selectedIngredientID) {
                ForEach(ingredients) { ingredient in
                    Text(ingredient.unitOfMeasure).tag(ingredient.id)
                }
            } // END OF PICKER
            .background(
                // read frame width size of picker
                GeometryReader {
                    Color.clear.preference(key: ViewWidthKey.self, value: $0.frame(in: .local).size.width)
                })
            .labelsHidden()
            .pickerStyle(.menu)
            .onChange(of: $selectedIngredientID.wrappedValue, perform: setIngredient)
        } // END OF ZSTACK
        .onPreferenceChange(ViewWidthKey.self) { value in
            self.pickerWidth = value
        }
    } // END OF BODY
    
    private func setIngredient(id: Ingredient.ID) {
        if let ingredient = ingredients.first(where: { $0.id == selectedIngredientID }) {
            selectedIngredient = ingredient
        }
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
