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
                        .fontWeight(.semibold)
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 4, trailing: 0))
                    
                    RecipeSummaryView(cal: recipe.nutritionData.calories,
                                      proteinInGrams: recipe.nutritionData.protein,
                                      fatInGrams: recipe.nutritionData.fat,
                                      carbInGrams: recipe.nutritionData.carb,
                                      format: "%.0f",
                                      showLabel: false,
                                      gridSpacing: 20)
                } // END OF VSTACK
            Spacer()
        } // END OF HSTACK
    } // END OF BODY
} // END OF STRUCT


struct RecipeListRowView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.ignoresSafeArea()
            
            VStack {
                
                RecipeListRowView(SampleData.recipieCilantroLimeChicken)
                    .background(.white)
                    .cornerRadius(10)
                
                RecipeListRowView(SampleData.recipieNoPhoto)
                    .foregroundColor(.white)
                    .background(.black)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}
