//
//  RecipieListView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/30/23.
//

import SwiftUI

struct RecipieListView: View {
    
    @StateObject private var viewModel: RecipieListViewModel = RecipieListViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.recipieArray) { recipie in
                
                RecipeListRowView(viewModel: RecipeListRowViewModel(recipe: SampleData.recipieCilantroLimeChicken))
                
                
            }
            .listRowSeparator(.hidden)
            .listRowBackground(
                RoundedRectangle(cornerRadius: 5)
                    .background(.clear)
                    .foregroundColor(.gray.opacity(0.2))
                    .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
            )
            
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



struct RecipieListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipieListView()
        }
    }
}
