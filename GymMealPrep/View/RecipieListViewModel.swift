//
//  RecipieListViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/30/23.
//

import Foundation

class RecipieListViewModel: ObservableObject {
    
    var recipieArray: [Recipie] {
        [Recipie(),
         Recipie(),
         Recipie(),
         Recipie()]
    }
}
