//
//  RecipieViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//

import Foundation
import SwiftUI
import UIKit

class RecipeViewModel: ObservableObject {
    
    //MARK: PUBLISHED PROPERTIES
    @Published var recipe: Recipe
    @Published var tagText = String()
    
    
    var totalTimeCookingInMinutes: Int {
        return (recipe.timeCookingInMinutes ?? 0)  + (recipe.timePreparingInMinutes ?? 0) + (recipe.timeCookingInMinutes ?? 0)
    }
    
    var timeSummaryData: [(String, String)] {
        [
            ("Prep", "\(recipe.timePreparingInMinutes ?? 0)"),
            ("Cook", "\(recipe.timeCookingInMinutes ?? 0)"),
            ("Wait", "\(recipe.timeWaitingInMinutes ?? 0)"),
            ("Total", "\(totalTimeCookingInMinutes)")
        ]
    }
    
    var nutritionalData: [String] {
        [
            String(format: "%.0f", recipe.nutritionData.calories) + "\n Cal",
            String(format: "%.0f", recipe.nutritionData.protein) + "g\n Protein",
            String(format: "%.0f", recipe.nutritionData.fat) + "g\n Fat",
            String(format: "%.0f", recipe.nutritionData.carb) + "g\n Carb",
        ]
    }
    
    var image: Image {
        if let imageData = recipe.imageData, let uiImage = UIImage(data: imageData) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "takeoutbag.and.cup.and.straw")
        }
    }
    
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
}
extension RecipeViewModel {
    
    func addTag() {
        let tag = Tag(id: UUID(), text: tagText)
        recipe.tags.append(tag)
        tagText = String()
        print("New tag added")
    }
    
}
