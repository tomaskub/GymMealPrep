//
//  RecipeListTabView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/12/23.
//

import SwiftUI

struct RecipeListTabView: View {
    
    enum NavigationState: Hashable {
        case showingRecipeDetailEdit(Recipe)
        case addingNewRecipeText
        case showingRecipeDetail(Recipe)
    }
    
    @StateObject private var viewModel: RecipeListViewModel
    @State private var path = NavigationPath()
    
    public init(viewModel: RecipeListViewModel = RecipeListViewModel()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            
            RecipeListView(viewModel: viewModel)
            
            //MARK: NAVIGATION DESTINATIONS
            .navigationDestination(for: NavigationState.self) { state in
                switch state {
                case .showingRecipeDetailEdit(let recipe):
                    RecipeHostView(isEditing: true, viewModel: viewModel.createRecipeViewModel(recipe: recipe), path: $path)
                case .addingNewRecipeText:
                    RecipeCreatorHostView(path: $path)
                case .showingRecipeDetail(let recipe):
                    RecipeHostView(viewModel: viewModel.createRecipeViewModel(recipe: recipe), path: $path)
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
