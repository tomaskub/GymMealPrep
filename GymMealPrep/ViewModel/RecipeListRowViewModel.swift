//
//  File.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/1/23.
//

import Foundation
import SwiftUI
import UIKit


class RecipeListRowViewModel: ObservableObject {
    
    var recipe: Recipe
    
    var name: String {
        recipe.name
    }
    
    var calories: String {
        String(format: "%.0f", recipe.nutritionData.calories)
    }
    
    var protein: String {
        String(format: "%.0f", recipe.nutritionData.protein)
    }
    
    var fat: String {
        String(format: "%.0f", recipe.nutritionData.fat)
    }
    
    var carb: String {
        String(format: "%.0f", recipe.nutritionData.carb)
    }
    
    var image: Image {
        guard let data = recipe.imageData, let uiImage = UIImage(data: data) else { return Image(systemName: "takeoutbag.and.cup.and.straw") }
        return Image(uiImage: uiImage)
    }
         
    init(recipe: Recipe) {
        self.recipe = recipe
    }
}
