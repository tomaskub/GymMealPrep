//
//  IngredientEditorView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/3/23.
//

import SwiftUI

struct IngredientEditorView: View {
    
    var body: some View {
        //TODO: ADD INGREDIENT MODIFICATION HERE
        VStack(alignment: .leading) {
            Text("Add new ingredient")
                .font(.title)
            Grid {
                GridRow{
                    Text("Name")
                    TextField("Name", text: .constant("Ingredient"))
                }
                GridRow {
                    Text("Quantity")
                    Rectangle()
                        .frame(width: 200,height: 100)
                }
                GridRow {
                    Rectangle()
                        .frame(width: 200)
                }
            }
            Spacer()
        }
        .padding()
    }
}

struct IngredientEditorView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientEditorView()
    }
}
