//
//  RecipieViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//

import Foundation
import SwiftUI

class RecipeViewModel: ObservableObject {
    
    //private
    @Published var recipe: Recipe
    
    
    //MARK: PUBLISHED PROPERTIES
    @Published var image: Image = Image("sampleRecipiePhoto")
    @Published var tagText = String()
    @Published var tagRows: [[Tag]] = []
    
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
    
    
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
}
extension RecipeViewModel {
    
    func addTag() {
        let tag = Tag(id: UUID(), text: tagText)
        recipe.tags.append(tag)
        tagText = String()
    }
    
}
