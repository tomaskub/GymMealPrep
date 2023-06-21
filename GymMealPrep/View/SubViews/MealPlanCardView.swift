//
//  MealPlanCardView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/21/23.
//

import SwiftUI

struct MealPlanCardView: View {
    let mealPlan: MealPlan
    var body: some View {
        VStack(alignment: .leading) {
            Text(mealPlan.name ?? "Meal plan")
                .font(.title3)
                .padding(.bottom, 4)
            ForEach(Array(mealPlan.meals.enumerated()), id: \.element) { index, meal  in
                Text("Meal #\(index)")
                    .padding(.top, 4)
                ForEach(meal.recipes) { recipe in
                    Text(recipe.name)
                }
            }
        }
        .padding()
        .background(.gray.opacity(0.2))
        .cornerRadius(25)
    }
}

struct MealPlanCardView_Previews: PreviewProvider {
    static var previews: some View {
        MealPlanCardView(mealPlan: MealPlan(name: "My bulking plan", meals: [
            Meal(recipies: [SampleData.recipieCilantroLimeChicken]),
            Meal(recipies: [SampleData.recipieCilantroLimeChicken]),
            Meal(recipies: [SampleData.recipieCilantroLimeChicken]),
            Meal(recipies: [SampleData.recipieCilantroLimeChicken]),
            Meal(recipies: [SampleData.recipieCilantroLimeChicken]),
        ]))
    }
}
