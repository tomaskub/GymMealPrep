//
//  RecipieListViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/30/23.
//

import Foundation
import SwiftUI

class RecipieListViewModel: ObservableObject {
    
    var image = Image("sampleRecipiePhoto")
    
    var recipieArray: [Recipie] = {
        [Recipie(),
         Recipie(),
         Recipie(),
         Recipie()]
    }()
}
