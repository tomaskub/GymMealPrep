//
//  RecipieListViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/30/23.
//

import Foundation
import SwiftUI

class RecipeListViewModel: ObservableObject {
    
    var recipieArray: [Recipe] = {
        [SampleData.recipieCilantroLimeChicken,
         SampleData.recipieCilantroLimeChicken,
         SampleData.recipieCilantroLimeChicken,
         SampleData.recipieCilantroLimeChicken]
    }()
}
