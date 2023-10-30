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
        case addingNewRecipeWeb
        case showingRecipeDetail(Recipe)
    }
    @EnvironmentObject private var container: Container
    @StateObject private var viewModel: RecipeListViewModel
    @State private var path = NavigationPath()
    
    public init(viewModel: RecipeListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            
            RecipeListView(viewModel: viewModel)
            
            //MARK: NAVIGATION DESTINATIONS
            .navigationDestination(for: NavigationState.self) { state in
                switch state {
                case .showingRecipeDetail(let recipe):
                    RecipeHostView(viewModel: RecipeViewModel(recipe: recipe,
                                                              dataManager: container.dataManager),
                                   path: $path)
                case .showingRecipeDetailEdit(let recipe):
                    RecipeHostView(viewModel: RecipeViewModel(recipe: recipe,
                                                              dataManager: container.dataManager),
                                   isEditing: true,
                                   path: $path)
                case .addingNewRecipeText:
                    RecipeCreatorHostView(viewModel: RecipeCreatorViewModel(dataManager: container.dataManager,
                                                                            networkController: container.networkController),
                                          path: $path)
                
                case .addingNewRecipeWeb:
                    RecipeCreatorHostView(viewModel: RecipeCreatorViewModel(dataManager: container.dataManager,
                                                                            networkController: container.networkController),
                                          path: $path,
                                          includeWebLink: true)
                }
            }
        }
    }
}

struct RecipeListTabView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListTabView(viewModel: RecipeListViewModel(dataManager: .preview))
            .environmentObject(Container())
    }
}
