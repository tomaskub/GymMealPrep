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

struct RecipePickerView: View {
    
    @Environment(\.dismiss) var dismiss
    var saveHandler: RecipeSaveHandler
    @StateObject private var viewModel: RecipePickerViewModel
    
    init(saveHandler: RecipeSaveHandler, viewModel: RecipePickerViewModel) {
        self.saveHandler = saveHandler
        self._viewModel = StateObject.init(wrappedValue: viewModel)
    }
    
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
    
    private class PreviewSaveHandler: RecipeSaveHandler {
        func addRecipe(_ recipeToSave: Recipe) {
            print("Recipe saved: \(recipeToSave.name)")
        }
    }
    
    private struct ContainerView: View {
        @StateObject private var container = Container()
        var body: some View {
            RecipePickerView(saveHandler: PreviewSaveHandler(),
                             viewModel: RecipePickerViewModel(dataManager: container.dataManager))
        }
    }
    
    static var previews: some View {
        ContainerView()
    }
}
