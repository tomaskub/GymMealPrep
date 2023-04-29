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
    
    init(recipie: Recipie) {
        self.recipie = recipie
    }
}
