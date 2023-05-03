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
    
    @Published var timePreparingInMinutes: String {
        didSet {
            let filtered = timePreparingInMinutes.filter({ "0123456789".contains($0) })
            if let newTime = Int(filtered) {
                recipe.timePreparingInMinutes = newTime
            }
        }
    }
    
    @Published var timeCookingInMinutes: String {
        didSet {
            let filtered = timeCookingInMinutes.filter({ "0123456789".contains($0) })
            if let newTime = Int(filtered) {
                recipe.timeCookingInMinutes = newTime
            }
        }
    }
    
    @Published var timeWaitingInMinutes: String {
        didSet {
            let filtered = timeWaitingInMinutes.filter({ "0123456789".contains($0) })
            if let newTime = Int(filtered) {
                recipe.timeWaitingInMinutes = newTime
            }
        }
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
        if let timePreparing = recipe.timePreparingInMinutes {
            self.timePreparingInMinutes = "\(timePreparing)"
        } else {
            self.timePreparingInMinutes = String()
            }
        if let timeCooking = recipe.timeCookingInMinutes {
            self.timeCookingInMinutes = "\(timeCooking)"
        } else {
            self.timeCookingInMinutes = String()
        }
        if let timeWaiting = recipe.timeWaitingInMinutes {
            self.timeWaitingInMinutes = "\(timeWaiting)"
        } else {
            self.timeWaitingInMinutes = String()
        }
    }
}
extension RecipeViewModel {
    
    /// Create tag with a new UUID and tagText to the recipie referenced by view model
    func addTag() {
        let tag = Tag(id: UUID(), text: tagText)
        recipe.tags.append(tag)
        tagText = String()
    }   
}
