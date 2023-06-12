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
    @Binding var isAddingNewRecipe: Bool
    @Binding var isAddingNewRecipeViaText: Bool
    
    
    
    var body: some View {
        
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
    } // END OF BODY
} // END OF STRUCT

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RecipeListView(
                viewModel: RecipeListViewModel(dataManager: .preview),
                isAddingNewRecipe: .constant(false),
                isAddingNewRecipeViaText: .constant(false)
            )
        }
    }
}
