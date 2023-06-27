//
//  DataManager+MealMOTests.swift
//  GymMealPrepTests
//
//  Created by Tomasz Kubiak on 6/26/23.
//

import XCTest
@testable import GymMealPrep

final class DataManager_MealMOTests: XCTestCase {
    
    var sut: DataManager!
    
    override func setUp() {
        sut = DataManager.testing
    }

    override func tearDown() {
        sut = nil
    }

    func testUpdateAndSave_whenNoMealExists() {
        let ingredient = Ingredient(food: Food(name: "Test food"), quantity: 1, unitOfMeasure: "cups", nutritionData: Nutrition.zero)
        let instruction = Instruction(step: 1, text: "Test instruction")
        let tag = Tag(text: "Test tag")
        let recipe = Recipe(id: UUID(), name: "Test Recipe", servings: 4, timeCookingInMinutes: 30, timePreparingInMinutes: 15, timeWaitingInMinutes: 0, ingredients: [ingredient], instructions: [instruction], tags: [tag])
        let ingredientTwo = Ingredient(food: Food(name: "Test food2"), quantity: 2, unitOfMeasure: "cups", nutritionData: Nutrition.zero)
        let meal = Meal(ingredients: [ingredientTwo] , recipies: [recipe])
        
        sut.updateAndSave(meal: meal)
        
        let result = sut.fetchFirst(MealMO.self, predicate: NSPredicate(format: "id = %@", meal.id as CVarArg))
        switch result {
        case .success(let success):
            if let mealMO = success {
                
                // test for recipe in retrieved meal
                do {
                    let recipeSet = try XCTUnwrap(mealMO.recipes, "Retrieved meal should have not nil recipe set")
                    let retrievedRecipes = recipeSet.compactMap({ $0 as? RecipeMO })
                    let retrievedRecipe = try XCTUnwrap(retrievedRecipes.first, "There should be first retrieved recipe")
                    XCTAssert(retrievedRecipe.id == recipe.id, "The first retrieved recipe id should match the saved recipe id")
                } catch {
                    XCTFail("Failed while testing for recipe in meal: \(error.localizedDescription)")
                }
                
                // test for ingredient
                do {
                    let ingredientSet = try XCTUnwrap(mealMO.ingredients, "Retrieved meal should have not nil ingredient set")
                    let retrievedIngredients = ingredientSet.compactMap({ $0 as? IngredientMO })
                    let retrievedIngredient = try XCTUnwrap(retrievedIngredients.first, "There should be first retrieved ingredient")
                    XCTAssert(retrievedIngredient.id == ingredient.id, "The first retrieved ingredient id should match the saved ingredient id")
                } catch {
                    XCTFail("Failed while testing for ingredient in meal: \(error.localizedDescription)")
                }
            }
        case .failure(let failure):
            XCTFail("Failure in retrieving saved result: \(failure.localizedDescription)")
        }
        
    }
    
    func testUpdateAndSave_whenMealExists() {
        let ingredient = Ingredient(food: Food(name: "Test food"), quantity: 1, unitOfMeasure: "cups", nutritionData: Nutrition.zero)
        let instruction = Instruction(step: 1, text: "Test instruction")
        let tag = Tag(text: "Test tag")
        let recipe = Recipe(id: UUID(), name: "Test Recipe", servings: 4, timeCookingInMinutes: 30, timePreparingInMinutes: 15, timeWaitingInMinutes: 0, ingredients: [ingredient], instructions: [instruction], tags: [tag])
        let ingredientTwo = Ingredient(food: Food(name: "Test food2"), quantity: 2, unitOfMeasure: "cups", nutritionData: Nutrition.zero)
        var meal = Meal(ingredients: [ingredientTwo] , recipies: [recipe])
        
        sut.updateAndSave(meal: meal)
        // meal not exists
        
        meal.ingredients.append(ingredient)
        
        sut.updateAndSave(meal: meal)
        
        let result = sut.fetchFirst(MealMO.self, predicate: NSPredicate(format: "id = %@", meal.id as CVarArg))
        switch result {
        case .success(let success):
            if let mealMO = success {
                // test for ingredient changed
                do {
                    let ingredientSet = try XCTUnwrap(mealMO.ingredients, "Retrieved meal should have not nil ingredient set")
                    let retrievedIngredients = ingredientSet.compactMap({ $0 as? IngredientMO })
                    XCTAssert(retrievedIngredients.count == 2, " There should be two ingredients")
                    
                    XCTAssert(retrievedIngredients.contains(where: {$0.id == ingredient.id}), "The retrieved ingredients should have element that matches the added ingredient id")
                    XCTAssert(retrievedIngredients.contains(where: {$0.id == ingredientTwo.id}), "The retrieved ingredients should have element that matches the saved ingredient id")
                } catch {
                    XCTFail("Failed while testing for ingredient in meal: \(error.localizedDescription)")
                }
            }
        case .failure(let failure):
            XCTFail("Failure in retrieving saved result: \(failure.localizedDescription)")
        }
        
    }
}
