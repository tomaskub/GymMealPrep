//
//  RecipeListRowView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/1/23.
//

import SwiftUI

struct RecipeListRowView: View {
    
    @ObservedObject var viewModel: RecipeListRowViewModel
    
    var body: some View {
        HStack {
            viewModel.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
            Spacer()
                VStack {
                    Text(viewModel.name)
                    HStack {
                        Text(viewModel.calories)
                        Text(viewModel.protein)
                        Text(viewModel.fat)
                        Text(viewModel.carb)
                    }
                }
            Spacer()
        }
    }
}


struct RecipeListRowView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListRowView(viewModel: RecipeListRowViewModel(recipe: SampleData.recipieCilantroLimeChicken))
    }
}
