//
//  MealPlanCardView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/21/23.
//

import SwiftUI

struct MealPlanCardView: View {
    let color: Color
    let mealPlan: MealPlan
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(mealPlan.name ?? "Meal plan")
                .font(.title3)
                .padding(.bottom, 4)
            
            NutritionStripeView(nutrition: mealPlan.nutrition)
            
            ForEach(Array(mealPlan.meals.enumerated()), id: \.element) { index, meal  in
                
                Text("Meal #\(index + 1)")
                    .padding(.top, 4)
                
                NutritionStripeView(nutrition: meal.nutrition)
                
                ForEach(meal.recipes) { recipe in
                    Text(recipe.name)
                }
                
                ForEach(meal.ingredients) { ingredient in
                    Text(generateIngredientLabel(ingredient:ingredient))
                }
            }
        } // END OF VSTACK
        .padding()
        .background(color)
        .cornerRadius(25)
    } // END OF BODY
    
    func generateIngredientLabel(ingredient: Ingredient) -> String {
        return ingredient.food.name + " " + String(ingredient.quantity) + " " + ingredient.unitOfMeasure
    }
}

struct MealPlanCardView_Previews: PreviewProvider {
    static var previews: some View {
        MealPlanCardView(color: Color.gray.opacity(0.2), mealPlan: MealPlan(name: "My bulking plan", meals: [
            Meal(recipies: [SampleData.recipieCilantroLimeChicken]),
            Meal(recipies: [SampleData.recipieCilantroLimeChicken]),
            Meal(recipies: [SampleData.recipieCilantroLimeChicken]),
            Meal(recipies: [SampleData.recipieCilantroLimeChicken]),
            Meal(ingredients: [Ingredient(food: Food(name: "Potatoes"), quantity: 250, unitOfMeasure: "grams", nutritionData: Nutrition(calories: 50, carb: 10, fat: 20, protein: 15))],
                 recipies: [SampleData.recipieCilantroLimeChicken]),
        ]))
    }
}
