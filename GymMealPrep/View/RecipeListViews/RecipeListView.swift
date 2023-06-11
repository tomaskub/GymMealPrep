//
//  RecipieListView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/30/23.
//

import SwiftUI

struct RecipeListView: View {
    
    @StateObject private var viewModel: RecipeListViewModel
    
    public init(viewModel: RecipeListViewModel = RecipeListViewModel()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
            List {
                
                ForEach(viewModel.recipeArray) { recipe in
                    NavigationLink {
                        RecipeHostView(viewModel: viewModel.createRecipeViewModel(recipe: recipe))
                    } label: {
                        RecipeListRowView(recipe)
                            .cornerRadius(20)
                    }
                } // END OF LIST ROWS
                .listRowSeparator(.hidden)
                
            } // END OF LIST
            .listStyle(.plain)
            
            .navigationTitle("Recipies")
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            RecipeHostView(isEditing: true, viewModel: viewModel.createRecipeViewModel(recipe: Recipe()))
                        } label: {
                            Image(systemName: "plus.circle")
                                .font(.title3)
                        }
                } // END OF TOOLBAR ITEM
                
                ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            RecipeCreatorView()
                        } label: {
                            Image(systemName: "text.badge.plus")
                        }
                } // END OF TOOLBAR ITEM
            } // END OF TOOLBAR
    } // END OF BODY
} // END OF STRUCT

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeListView(viewModel: RecipeListViewModel(dataManager: .preview))
        }
    }
}
