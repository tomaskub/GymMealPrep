//
//  RecipieListView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/30/23.
//

import SwiftUI

struct RecipeListView: View {
    
    @StateObject private var viewModel: RecipeListViewModel
    
    @State private var isExpanded: Bool = false
    @State private var isAddingNewRecipe: Bool = false
    @State private var isAddingNewRecipeViaText: Bool = false
    
    public init(viewModel: RecipeListViewModel = RecipeListViewModel()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.recipeArray) { recipe in
                    
                    NavigationLink(value: recipe) {
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
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                            .rotationEffect(Angle(degrees: isExpanded ? 180 : 0), anchor: UnitPoint(x: 0.5, y: 0.5))
                            .onTapGesture {
                                isExpanded.toggle()
                            }
                            .animation(.easeInOut(duration: 0.5), value: isExpanded)
                        if isExpanded {
                            Button {
                                isAddingNewRecipeViaText.toggle()
                            } label: {
                                Text("Add from text")
                            }
                            //TODO: Figure out why transition have unexpected behaviour
                            .transition(.asymmetric(
                                insertion: .opacity.animation(.linear(duration: 0.5)),
                                removal: .opacity.animation(.linear(duration: 0.1)))
                            )
                        }
                        Button {
                            isAddingNewRecipe.toggle()
                        } label: {
                            Image(systemName: "plus.circle")
                                .font(.title3)
                        }
                    }
                    
                } // END OF TOOLBAR ITEM
            } // END OF TOOLBAR
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
            
            
        } // END OF NAVIGATION STACK
    } // END OF BODY
} // END OF STRUCT

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeListView(viewModel: RecipeListViewModel(dataManager: .preview))
        }
    }
}
