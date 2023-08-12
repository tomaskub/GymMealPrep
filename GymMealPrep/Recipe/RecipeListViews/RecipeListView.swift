//
//  RecipieListView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/30/23.
//

import SwiftUI

struct RecipeListView: View {
    
    @ObservedObject var viewModel: RecipeListViewModel
    
    @State private var isExpanded: Bool = false
    
    private typealias NavigationState = RecipeListTabView.NavigationState
    private let toolbarButtonTransition = AnyTransition
        .asymmetric(insertion: .opacity.animation(.linear(duration: 0.5)),
                    removal: .opacity.animation(.linear(duration: 0.1)))
    
    var body: some View {
        
        List {
            ForEach(viewModel.recipeArray) { recipe in
                
                NavigationLink(value: NavigationState.showingRecipeDetail(recipe)) {
                    RecipeListRowView(recipe)
                        .cornerRadius(20)
                }
            } // END OF LIST ROWS
            .onDelete(perform: { indexSet in
                viewModel.deleteRecipe(atOffsets: indexSet)
            })
            .listRowSeparator(.hidden)
            
        } // END OF LIST
        .listStyle(.plain)
        .navigationTitle("Recipes")
        
        .toolbar {
            toolbar
        } // END OF TOOLBAR
    } // END OF BODY
    
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            
            HStack {
                
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
                    .rotationEffect(Angle(degrees: isExpanded ? 180 : 0), anchor: UnitPoint(x: 0.5, y: 0.5))
                    .onTapGesture {
                        isExpanded.toggle()
                    }
                    .animation(.easeInOut(duration: 0.5), value: isExpanded)
//TODO: Figure out why transition have unexpected behaviour
                if isExpanded {
                    NavigationLink(value: NavigationState.addingNewRecipeText) {
                        toolbarTextButton(text: "Add from text")
                    }
                    .transition(toolbarButtonTransition)
                    
                    NavigationLink(value: NavigationState.addingNewRecipeWeb) {
                        toolbarTextButton(text: "Add from web")
                    }
                    .transition(toolbarButtonTransition)
                }
                
                NavigationLink(value: RecipeListTabView.NavigationState.showingRecipeDetailEdit(Recipe())) {
                    Image(systemName: "plus.circle")
                        .font(.title3)
                }
            } // END OF HSTACK
        } // END OF TOOLBAR ITEM
    } // END OF VARIABLE
} // END OF STRUCT

extension RecipeListView {
    @ViewBuilder
    func toolbarTextButton(text: String) -> some View {
        Text(text)
            .foregroundColor(.white)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(
                Capsule()
                    .foregroundColor(.blue)
            )
    } // END OF VIEW BUILDER
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RecipeListView(viewModel: RecipeListViewModel(dataManager: .preview))
        }
    }
}
