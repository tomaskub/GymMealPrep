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
            ForEach(viewModel.recipieArray, id: \.self.id) { recipie in
                
                HStack {
                    viewModel.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 100)
                    VStack {
                        Text(viewModel.recipieArray[0].name)
                        HStack {
                            Text(String(format: "%.0f", viewModel.recipieArray[0].nutritionData.calories))
                            Text(String(format: "%.0f", viewModel.recipieArray[0].nutritionData.protein))
                            Text(String(format: "%.0f", viewModel.recipieArray[0].nutritionData.fat))
                            Text(String(format: "%.0f", viewModel.recipieArray[0].nutritionData.carb))
                        }
                    }
                    
                }
                .listRowInsets(EdgeInsets())
                .cornerRadius(10)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(
                RoundedRectangle(cornerRadius: 5)
                    .background(.clear)
                    .foregroundColor(.gray)
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
