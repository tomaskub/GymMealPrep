//
//  NutritionStripeView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/8/23.
//

import SwiftUI

struct NutritionStripeView: View {
    
    let nutrition: any NutritionProtocol
    
    var body: some View {
        HStack {
            Text("Calories")
                .foregroundColor(.gray)
            Text(String(nutrition.calories))
            Text("Fat")
                .foregroundColor(.gray)
            Text(String(nutrition.fat))
            Text("Carbs")
                .foregroundColor(.gray)
            Text(String(nutrition.carb))
            Text("Protein")
                .foregroundColor(.gray)
            Text(String(nutrition.protein))
        }
        .font(.caption)
    }
}

struct NutritionStripeView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionStripeView(nutrition: Nutrition(calories: 1000, carb: 45.3, fat: 20, protein: 34.99))
    }
}
