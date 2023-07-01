//
//  NutritionStripeView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/8/23.
//

import SwiftUI

struct NutritionStripeView: View {
    
    let nutrition: any NutritionProtocol
    
    let formatter: NumberFormatter = {
       let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter
    }()
    
    var body: some View {
        HStack {
            Text("Calories")
                .foregroundColor(.gray)
            Text(formatedValue(nutrition.calories))
            Text("Fat")
                .foregroundColor(.gray)
            Text(formatedValue(nutrition.fat))
            Text("Carbs")
                .foregroundColor(.gray)
            Text(formatedValue(nutrition.carb))
            Text("Protein")
                .foregroundColor(.gray)
            Text(formatedValue(nutrition.protein))
            
        } // END OF H STACK
        .font(.caption)
    } // END OF BODY
    
    private func formatedValue(_ value: Float) -> String {
        formatter.string(from: NSNumber(value: value)) ?? "0.0"
    }
} // END OF STRUCT

struct NutritionStripeView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionStripeView(nutrition: Nutrition(calories: 1000, carb: 45.3, fat: 20, protein: 34.00000999))
    }
}
