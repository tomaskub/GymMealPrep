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
                    RecipeHostView(recipe: recipe)
                } label: {
                    RecipeListRowView(recipe)
                        .cornerRadius(20)
                }

                
            }
            .listRowSeparator(.hidden)
//            .listRowBackground(
//                RoundedRectangle(cornerRadius: 5)
//                    .background(.clear)
//                    .foregroundColor(.gray.opacity(0.2))
//                    .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
//            )
            
        }
        .listStyle(.plain)
        
        
            .navigationTitle("Recipies")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "plus.circle")
                        .font(.title3)
                }
            }
    }
}



struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeListView(viewModel: RecipeListViewModel(dataManager: .preview))
        }
    }
}
