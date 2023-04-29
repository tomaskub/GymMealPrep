//
//  RecipieViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//

import Foundation
import SwiftUI

class RecipieViewModel: ObservableObject {
    
    var recipie: Recipie
    
    
    @Published var image: Image = Image("sampleRecipiePhoto")
    
    var totalTimeCookingInMinutes: Int {
        return recipie.timeCookingInMinutes + recipie.timePreparingInMinutes + recipie.timeCookingInMinutes
    }
    
    var timeSummaryData: [(String, String)] {
        [
            ("Prep", "\(recipie.timePreparingInMinutes)"),
            ("Cook", "\(recipie.timeCookingInMinutes)"),
            ("Wait", "\(recipie.timeWaitingInMinutes)"),
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
}
