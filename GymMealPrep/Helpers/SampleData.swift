//
//  SampleData.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/1/23.
//

import Foundation
import UIKit

struct SampleData {
    
    static let imageData = UIImage(named: "sampleRecipiePhoto")?.jpegData(compressionQuality: 1)
    
    static let recipieCilantroLimeChicken = Recipe(
        id: UUID(),
        name: "Cilantro Lime Chicken",
        servings: 4,
        timeCookingInMinutes: 30,
        timePreparingInMinutes: 15,
        timeWaitingInMinutes: 5,
        ingredients: [
            Ingredient(food: Food(id: UUID(), name: "Chicken breast"), quantity: 2, unitOfMeasure: "each", nutritionData: Nutrition(calories: 600, carb: 12, fat: 10, protein: 30)),
            Ingredient(food: Food(id: UUID(), name: "Olive oil"), quantity: 1, unitOfMeasure: "tablespoon", nutritionData: Nutrition()),
            Ingredient(food: Food(id: UUID(), name: "Basmati rice"), quantity: 2, unitOfMeasure: "cups", nutritionData: Nutrition())],
        instructions: [
            Instruction(id: UUID(), step: 1, text: "Place the chicken in a ziploc bag together with the olive oil, garlic, cumin, salt, pepper, and juice of 1 lime. Allow it to marinate for 15-20 min over the counter."),
            Instruction(id: UUID(), step: 2, text: "Preheat a skillet over medium-high heat. Cook the chicken for 3-5 minutes per side, or until cooked through."),
            Instruction(id: UUID(), step: 3, text: "Set aside and allow it to sit for 10 minutes, then slice.")],
        imageData: imageData,
        tags: [Tag(id: UUID(), text: "Chicken"),
               Tag(id: UUID(), text: "Rice"),
               Tag(id: UUID(), text: "Cilantro"),
               Tag(id: UUID(), text: "Lunch"),
               Tag(id: UUID(), text: "Lime"),
              Tag(text: "Dinner")])
    
    static let recipeBreakfastPotatoHash = Recipe(
        name: "Breakfast potato hash",
        servings: 1,
        timeCookingInMinutes: 15,
        timePreparingInMinutes: 5,
        timeWaitingInMinutes: 0,
        ingredients: [
        Ingredient(food: Food(name: "Potatoes"), quantity: 250, unitOfMeasure: "gram", nutritionData: Nutrition(calories: 192, carb: 44, fat: 0, protein: 5)),
        Ingredient(food: Food(name: "Onions"), quantity: 70, unitOfMeasure: "gram", nutritionData: Nutrition(calories: 28, carb: 7, fat: 0, protein: 1)),
        Ingredient(food: Food(name: "Chicken ham"), quantity: 100, unitOfMeasure: "gram", nutritionData: Nutrition(calories: 155, carb: 26, fat: 2, protein: 8)),
        Ingredient(food: Food(name: "Olive oil"), quantity: 7, unitOfMeasure: "gram", nutritionData: Nutrition(calories: 62, carb: 0, fat: 7, protein: 0)),
        Ingredient(food: Food(name: "Eggs"), quantity: 3, unitOfMeasure: "whole", nutritionData: Nutrition(calories: 210, carb: 3, fat: 15, protein: 18)),
        Ingredient(food: Food(name: "Soy Sauce"), quantity: 25, unitOfMeasure: "ml", nutritionData: Nutrition(calories: 1, carb: 0, fat: 0, protein: 0)),
        Ingredient(food: Food(name: "Salt"), quantity: 1, unitOfMeasure: "teaspoon", nutritionData: Nutrition.zero),
        Ingredient(food: Food(name: "Black pepper"), quantity: 1, unitOfMeasure: "teaspoon", nutritionData: Nutrition.zero),
        Ingredient(food: Food(name: "Chili powder"), quantity: 1, unitOfMeasure: "teaspoon", nutritionData: Nutrition.zero)],
        instructions: [
            Instruction(step: 1, text: "Peel or clean the potatoes with a brush, then cut the potatoes into small cubes, about half inch. Place the potatoes in a bowl and microwave for 6 minutes at 600W"),
            Instruction(step: 2, text: "Dice onion and chicken ham"),
            Instruction(step: 3, text: "Heat pan on high heat and add olive oils with microwaved potatoes"),
            Instruction(step: 4, text: "After potatoes are browned add ham and onion, keep frying for about 3 minutes. Add more oil if needed"),
            Instruction(step: 5, text: "Make small wells in the pan for the eggs, then crack in the egss, add three splashes of soy sauce and imidiately cover with a lid"),
            Instruction(step: 6, text: "Cook for 2 to 3 minutes and serve")
        ],
        imageData: nil,
        tags: [Tag(text: "Breakfast"), Tag(text: "Eggs"), Tag(text: "High protein")])
    
    static let recipeSlowCookerChickenTikkaMasala = Recipe(
        name: "Slow cooker chicken tikka masala",
        servings: 7,
        timeCookingInMinutes: 240,
        timePreparingInMinutes: 30,
        timeWaitingInMinutes: 0,
        ingredients: [
            Ingredient(food: Food(name: "Boneless, skinless chicken breast"), quantity: 2, unitOfMeasure: "lbs", nutritionData: Nutrition(calories: 960, carb: 0, fat: 8, protein: 208)),
            Ingredient(food: Food(name: "Lemon juice"), quantity: 1, unitOfMeasure: "tablespoon", nutritionData: Nutrition(calories: 3, carb: 1, fat: 0, protein: 0)),
            Ingredient(food: Food(name: "Yoghurt"), quantity: 3, unitOfMeasure: "tablespoons", nutritionData: Nutrition(calories: 6, carb: 1, fat: 0, protein: 0)),
            Ingredient(food: Food(name: "Chili powder"), quantity: 1, unitOfMeasure: "tablespoon", nutritionData: Nutrition.zero),
            Ingredient(food: Food(name: "Turmeric, grounds"), quantity: 0.5, unitOfMeasure: "teaspoon", nutritionData: Nutrition.zero),
            Ingredient(food: Food(name: "Garam Masala"), quantity: 1.5, unitOfMeasure: "teaspoon", nutritionData: Nutrition.zero),
            Ingredient(food: Food(name: "Ginger"), quantity: 1, unitOfMeasure: "tablesoon", nutritionData: Nutrition(calories: 69, carb: 15, fat: 1, protein: 2)),
            Ingredient(food: Food(name: "Garlic"), quantity: 1, unitOfMeasure: "tablespoon", nutritionData: Nutrition(calories: 13, carb: 3, fat: 0, protein: 1)),
            Ingredient(food: Food(name: "Vegetable oil"), quantity: 2, unitOfMeasure: "tablespoons", nutritionData: Nutrition(calories: 240, carb: 0, fat: 28, protein: 0)),
            Ingredient(food: Food(name: "Yellow onion"), quantity: 2, unitOfMeasure: "whole - medium", nutritionData: Nutrition(calories: 90, carb: 22, fat: 0, protein: 2)),
            Ingredient(food: Food(name: "Tomato puree"), quantity: 1.5, unitOfMeasure: "cups", nutritionData: Nutrition(calories: 306, carb: 0, fat: 0, protein: 0)),
            Ingredient(food: Food(name: "Heavy cream"), quantity: 0.75, unitOfMeasure: "cup", nutritionData: Nutrition(calories: 612, carb: 5, fat: 65, protein: 5))
        ],
        instructions: [
            Instruction(step: 1, text: "Cut the chicken breasts into 2 to 3-inch cubes. Add 2 teaspoon salt and lemon juice and mix well. Add yogurt, red chili powder, turmeric, garam masala, ginger, and garlic. Mix well and allow to marinate while you prep the remaining ingredients."),
            Instruction(step: 2, text: "Heat oil in a medium pan. Add onions and ½ teaspoon of salt. Cook over medium heat for 5 minutes stirring frequently until the onions start to soften and turn translucent. Note: If you are using Instant Pot as a slow cooker, you can saute in the instant pot itself."),
            Instruction(step: 3, text: "Add the cooked onions to the crockpot / slow cooker and spread it evenly. Evenly layer tomato puree over the onions. Line the marinated chicken over the tomato puree. Place the crockpot lid and set the cooking time to Slow Cook (Hi) and adjust the cooking time to 4 hours."),
            Instruction(step: 4, text: "After 4 hours, your kitchen will be filled with the beautiful aromas of the curry. Add heavy cream, crush the fenugreek leaves on the palm of your hands and add to the curry. Mix well, taste, and add tomato paste. Mix well and more cream if needed. Note: Optionally you can add 1 teaspoon of sugar to balance all the flavors. Garnish with cilantro and enjoy with basmati rice and naan.")],
        imageData: nil,
        tags: [
        Tag(text: "Chicken"), Tag(text: "Indian"), Tag(text: "Slow cooker")])
    
    
    static let recipieNoPhoto = Recipe(id: UUID(),
                                       name: "KFC chicken",
                                       servings: 2,
                                       timeCookingInMinutes: 0,
                                       timePreparingInMinutes: 0,
                                       timeWaitingInMinutes: 0, ingredients: [], instructions: [], tags: [])
    
    static var sampleParsedIngredientRowData: [Ingredient] {
        
        let food = Food(name: "Chicken")
        let baseNutri = Nutrition(calories: 215, carb: 0, fat: 15.1, protein: 18.6)
        return [
        Ingredient(food: food , quantity: 1, unitOfMeasure: "Whole", nutritionData: baseNutri.multiplyBy(12)),
        Ingredient(food: food, quantity: 1, unitOfMeasure: "Whole (small)", nutritionData: baseNutri.multiplyBy(10)),
        Ingredient(food: food, quantity: 1, unitOfMeasure: "Whole (boneless)", nutritionData: baseNutri.multiplyBy(9.2))
        ]
    }
    
    static var sampleMealPlan: MealPlan {
        let breakfast = Meal(recipies: [recipeBreakfastPotatoHash])
        let lunch = Meal(ingredients: [Ingredient(food: Food(name: "Rice"), quantity: 50, unitOfMeasure: "grams", nutritionData: Nutrition(calories: 65, carb: 14, fat: 0.2, protein: 1.4))], recipies: [recipeSlowCookerChickenTikkaMasala])
        let dinner = Meal(ingredients: [
            Ingredient(food: Food(name: "Pork shoulder"), quantity: 200, unitOfMeasure: "grams", nutritionData: Nutrition(calories: 514, carb: 0, fat: 43, protein: 32)),
            Ingredient(food: Food(name: "Potatoes"), quantity: 250, unitOfMeasure: "gram", nutritionData: Nutrition(calories: 192, carb: 44, fat: 0, protein: 5)),
            Ingredient(food: Food(name: "Coleslaw"), quantity: 100, unitOfMeasure: "grams", nutritionData: Nutrition(calories: 98, carb: 11, fat: 6, protein: 1))
        ])
        return MealPlan(name: "Sample Test Plan", meals: [breakfast, lunch, dinner])
    }
}
