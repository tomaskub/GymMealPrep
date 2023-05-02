//
//  RecipieViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//

import Foundation
import SwiftUI

class RecipieViewModel: ObservableObject {
    
    //private
    @Published var recipie: Recipie
    
    
    //MARK: PUBLISHED PROPERTIES
    @Published var image: Image = Image("sampleRecipiePhoto")
    @Published var tagText = String()
    var totalTimeCookingInMinutes: Int {
        return (recipie.timeCookingInMinutes ?? 0)  + (recipie.timePreparingInMinutes ?? 0) + (recipie.timeCookingInMinutes ?? 0)
    }
    
    var timeSummaryData: [(String, String)] {
        [
            ("Prep", "\(recipie.timePreparingInMinutes ?? 0)"),
            ("Cook", "\(recipie.timeCookingInMinutes ?? 0)"),
            ("Wait", "\(recipie.timeWaitingInMinutes ?? 0)"),
            ("Total", "\(totalTimeCookingInMinutes)")
        ]
    }
    
    var nutritionalData: [String] {
        [
            String(format: "%.0f", recipie.nutritionData.calories) + "\n Cal",
            String(format: "%.0f", recipie.nutritionData.protein) + "g\n Protein",
            String(format: "%.0f", recipie.nutritionData.fat) + "g\n Fat",
            String(format: "%.0f", recipie.nutritionData.carb) + "g\n Carb",
        ]
    }
    
    
    
    init(recipie: Recipie) {
        self.recipie = recipie
        
        
        
    }
    
    func addTag() {
        let tag = Tag(id: UUID(), text: tagText)
        recipie.tags.append(tag)
        tagText = String()
    }
    
}
