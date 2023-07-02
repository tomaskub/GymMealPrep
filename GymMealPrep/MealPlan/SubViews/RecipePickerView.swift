//
//  RecipePickerView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 7/2/23.
//

import SwiftUI

protocol RecipeSaveHandler {
    func addRecipe(_: Recipe)
}

struct RecipePickerView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct RecipePickerView_Previews: PreviewProvider {
    static var previews: some View {
        RecipePickerView()
    }
}
