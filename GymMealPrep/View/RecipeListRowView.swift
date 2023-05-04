//
//  RecipeListRowView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/1/23.
//

import SwiftUI
import UIKit

/// Row view dedicated to displaying a recipie summary, inlcuding image, name and nutrition data
struct RecipeListRowView: View {

    let recipe: Recipe
    let recipeImage: Image
    
    /// Initializer taking a recipie as a parameter and creting a view with image, name and nutritional data. If recipe does not have an image, a system placeholder will be shown instead.
    /// - Parameter recipe: Recipe to be displayed by the view
    public init(_ recipe: Recipe) {
        self.recipe = recipe
        if let data = recipe.imageData, let uiImage = UIImage(data: data) {
            self.recipeImage = Image(uiImage: uiImage)
        } else {
            self.recipeImage = Image(systemName: "takeoutbag.and.cup.and.straw")
        }
    }
    
    var body: some View {
        HStack {
            
            recipeImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
            
            Spacer()
            
                VStack {
                    Text(recipe.name)
                    HStack {
                        Text(String(format: "%.0f", recipe.nutritionData.calories))
                        
                        Text(String(format: "%.0f", recipe.nutritionData.protein))
                        
                        Text(String(format: "%.0f", recipe.nutritionData.fat))
                        
                        Text(String(format: "%.0f", recipe.nutritionData.carb))
                    }// END OF HSTACK
                } // END OF VSTACK
            Spacer()
        }// END OF HSTACK
    }
}


struct RecipeListRowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            RecipeListRowView(SampleData.recipieCilantroLimeChicken)
            RecipeListRowView(SampleData.recipieNoPhoto)
        }
    }
}
