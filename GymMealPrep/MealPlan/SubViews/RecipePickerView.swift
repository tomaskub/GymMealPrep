//
//  RecipePickerView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 7/2/23.
//

import SwiftUI

protocol RecipeSaveHandler {
    func addRecipe(_: Recipe)
}

struct RecipePickerView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var saveHandler: RecipeSaveHandler
    @State var searchTerm: String = String()
    @State var recipes = [Recipe]()
    
    var body: some View {
        VStack {
            HStack {
            TextField("Type in recipe name", text: $searchTerm)
                .textFieldStyle(.roundedBorder)
                Button {
                    //search for recipe and populate the list
                    recipes.append(SampleData.recipeBreakfastPotatoHash)
                } label: {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .font(.title)
                }
            }.padding(.horizontal)
            List {
                ForEach(recipes) { recipe in
                    RecipeListRowView(recipe)
                        .onTapGesture {
                            saveHandler.addRecipe(recipe)
                            self.dismiss()
                        }
                }
            }
            .listStyle(.inset)
        }
    }
}

struct RecipePickerView_Previews: PreviewProvider {
    class PreviewSaveHandler: RecipeSaveHandler {
        func addRecipe(_ recipeToSave: Recipe) {
            print("Recipe saved: \(recipeToSave)")
        }
    }
    static var previews: some View {
        RecipePickerView(saveHandler: PreviewSaveHandler())
    }
}
