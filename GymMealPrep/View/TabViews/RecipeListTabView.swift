//
//  RecipeListTabView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/12/23.
//

import SwiftUI

struct RecipeListTabView: View {
    
    enum NavigationState: Hashable {
        case addingNewRecipeManually(Recipe)
        case addingNewRecipeText
        case showingRecipeDetail(Recipe)
    }
    
    @StateObject private var viewModel: RecipeListViewModel
    
    @State private var isAddingNewRecipe: Bool = false
    @State private var isAddingNewRecipeViaText: Bool = false
    
    public init(viewModel: RecipeListViewModel = RecipeListViewModel()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            
            RecipeListView(viewModel: viewModel)
            
            //MARK: NAVIGATION DESTINATIONS
            .navigationDestination(for: NavigationState.self) { state in
                switch state {
                case .addingNewRecipeManually(let recipe):
                    RecipeHostView(isEditing: true, viewModel: viewModel.createRecipeViewModel(recipe: recipe))
                case .addingNewRecipeText:
                    RecipeCreatorView()
                case .showingRecipeDetail(let recipe):
                    RecipeHostView(viewModel: viewModel.createRecipeViewModel(recipe: recipe))
                }
            }
        }
    }
}

struct RecipeListTabView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListTabView(viewModel: RecipeListViewModel(dataManager: .preview))
    }
}
