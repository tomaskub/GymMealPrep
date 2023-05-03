//
//  SampleData.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/1/23.
//

import Foundation

class SampleData {
    
    static let recipieCilantroLimeChicken = Recipie(
        id: UUID(),
        name: "Cilantro Lime Chicken",
        servings: 4,
        timeCookingInMinutes: 30,
        timePreparingInMinutes: 15,
        timeWaitingInMinutes: 5,
        ingredients: [
            Ingredient(food: Food(id: UUID(), name: "Chicken breast"), quantity: 2, unitOfMeasure: "each", nutritionData: Nutrition()),
            Ingredient(food: Food(id: UUID(), name: "Olive oil"), quantity: 1, unitOfMeasure: "tablespoon", nutritionData: Nutrition()),
            Ingredient(food: Food(id: UUID(), name: "Basmati rice"), quantity: 2, unitOfMeasure: "cups", nutritionData: Nutrition())],
        instructions: [
            Instruction(id: UUID(), step: 1, text: "Place the chicken in a ziploc bag together with the olive oil, garlic, cumin, salt, pepper, and juice of 1 lime. Allow it to marinate for 15-20 min over the counter."),
            Instruction(id: UUID(), step: 2, text: "Preheat a skillet over medium-high heat. Cook the chicken for 3-5 minutes per side, or until cooked through."),
            Instruction(id: UUID(), step: 3, text: "Set aside and allow it to sit for 10 minutes, then slice.")],
        tags: [Tag(id: UUID(), text: "Chicken"),
               Tag(id: UUID(), text: "Rice"),
               Tag(id: UUID(), text: "Cilantro"),
               Tag(id: UUID(), text: "Lunch"),
               Tag(id: UUID(), text: "Lime")],
        nutritionData: Nutrition(calories: 800, carb: 30, fat: 18, protein: 38))
    
}
