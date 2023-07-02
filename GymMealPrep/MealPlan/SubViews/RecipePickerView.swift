//
//  RecipePickerView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 7/2/23.
//

import SwiftUI
import Combine

protocol RecipeSaveHandler {
    func addRecipe(_: Recipe)
}

class RecipePickerViewModel: ObservableObject {
    @Published var searchTerm: String
    @Published var retrievedRecipes: [Recipe]
    
    private var dataManager: DataManager
    
    init(searchTerm: String = String(), retrievedRecipes: [Recipe] = [Recipe](), dataManager: DataManager = .shared) {
        self.searchTerm = searchTerm
        self.retrievedRecipes = retrievedRecipes
        self.dataManager = dataManager
    }
    
    func searchRecipes() {
        if searchTerm.isEmpty {
            retrievedRecipes = dataManager.recipeArray
        } else {
            retrievedRecipes = dataManager.recipeArray.filter({ $0.name.lowercased().contains(searchTerm.lowercased())
            })
        }
    }
}
struct RecipePickerView: View {
    
    @Environment(\.dismiss) var dismiss
    var saveHandler: RecipeSaveHandler
    @StateObject var viewModel: RecipePickerViewModel
    
    var body: some View {
        VStack {
            
            HStack {
                TextField("Type in recipe name", text: $viewModel.searchTerm)
                .textFieldStyle(.roundedBorder)
                Button {
                    viewModel.searchRecipes()
                } label: {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .font(.title)
                }
            }
            .padding(.horizontal)
            
            List {
                ForEach(viewModel.retrievedRecipes) { recipe in
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
        RecipePickerView(saveHandler: PreviewSaveHandler(), viewModel: RecipePickerViewModel(dataManager: .preview))
    }
}
