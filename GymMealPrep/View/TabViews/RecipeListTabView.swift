//
//  RecipeListTabView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/12/23.
//

import SwiftUI

struct RecipeListTabView: View {
    
    @StateObject private var viewModel: RecipeListViewModel
    
    @State private var isAddingNewRecipe: Bool = false
    @State private var isAddingNewRecipeViaText: Bool = false
    
    public init(viewModel: RecipeListViewModel = RecipeListViewModel()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            
            RecipeListView(viewModel: viewModel,
                           isAddingNewRecipe: $isAddingNewRecipe,
                           isAddingNewRecipeViaText: $isAddingNewRecipeViaText)
            
            //MARK: NAVIGATION DESTINATIONS
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeHostView(viewModel: viewModel.createRecipeViewModel(recipe: recipe))
            }
            .navigationDestination(isPresented: $isAddingNewRecipe) {
                RecipeHostView(isEditing: true, viewModel: viewModel.createRecipeViewModel(recipe: Recipe()))
            }
            .navigationDestination(isPresented: $isAddingNewRecipeViaText) {
                RecipeCreatorView()
            }
        }
    }
}

struct RecipeListTabView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListTabView(viewModel: RecipeListViewModel(dataManager: .preview))
    }
}
