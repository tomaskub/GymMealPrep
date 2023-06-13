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
    
    var body: some View {
        
            List {
                ForEach(viewModel.recipeArray) { recipe in
                    
                    NavigationLink(value: RecipeListTabView.NavigationState.showingRecipeDetail(recipe)) {
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
                            NavigationLink(value: RecipeListTabView.NavigationState.addingNewRecipeText) {
                                Text("Add from text")
                                    .padding(.all, 3)
                                    .background(
                                    Capsule()
                                        .foregroundColor(.gray.opacity(0.3))
                                    )
                            }
                            //TODO: Figure out why transition have unexpected behaviour
                            .transition(.asymmetric(
                                insertion: .opacity.animation(.linear(duration: 0.5)),
                                removal: .opacity.animation(.linear(duration: 0.1)))
                            )
                        }
                        
                        NavigationLink(value: RecipeListTabView.NavigationState.addingNewRecipeManually(Recipe())) {
                            Image(systemName: "plus.circle")
                                .font(.title3)
                        }
                    } // END OF HSTACK
                } // END OF TOOLBAR ITEM
            } // END OF TOOLBAR
    } // END OF BODY
} // END OF STRUCT

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RecipeListView(viewModel: RecipeListViewModel(dataManager: .preview))
        }
    }
}
