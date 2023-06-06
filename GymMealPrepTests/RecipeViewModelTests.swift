//
//  RecipeViewModelTests.swift
//  GymMealPrepTests
//
//  Created by Tomasz Kubiak on 5/12/23.
//

import XCTest
@testable import GymMealPrep

final class RecipeViewModelTests: XCTestCase {
    
    let recipe: Recipe = Recipe(name: "Test recipe", servings: 1, timeCookingInMinutes: 0, timePreparingInMinutes: 0, timeWaitingInMinutes: 0, ingredients: [], instructions: [], tags: [])
    var sut: RecipeViewModel!
    
    override func setUp() {
        sut = RecipeViewModel(recipe: recipe, dataManager: DataManager.testing)
    }
    
    override func tearDown() {
        sut = nil
    }
}


//MARK: TEST ADDING INGREDIENTS
extension RecipeViewModelTests {
    
    func testAddingIngredient() {
        let ingredient = Ingredient(food: Food(name: "Test food"), quantity: 1, unitOfMeasure: "cup", nutritionData: Nutrition(calories: 100, carb: 10, fat: 20, protein: 30))
        sut.addIngredient(ingredient, nil)
        print(sut.recipe.nutritionData.calories)
        XCTAssertTrue(sut.recipe.nutritionData.calories == ingredient.nutritionData.calories, "Calories should match")
        XCTAssertTrue(sut.recipe.nutritionData.protein == ingredient.nutritionData.protein, "Calories should match")
        XCTAssertTrue(sut.recipe.nutritionData.fat == ingredient.nutritionData.fat, "Calories should match")
        XCTAssertTrue(sut.recipe.nutritionData.carb == ingredient.nutritionData.carb, "Calories should match")
    }
   
    
    func testAddingMultipleIngredients() {
        let ingredientOne = Ingredient(food: Food(name: "Test food"), quantity: 1, unitOfMeasure: "cup", nutritionData: Nutrition(calories: 100, carb: 10, fat: 20, protein: 30))
        let ingredientTwo = Ingredient(food: Food(name: "Test food2"), quantity: 1, unitOfMeasure: "cup", nutritionData: Nutrition(calories: 200, carb: 20, fat: 30, protein: 40))
        let testResult = Nutrition(calories: 300, carb: 30, fat: 50, protein: 70)
        sut.addIngredient(ingredientOne, nil)
        sut.addIngredient(ingredientTwo, nil)
        XCTAssertTrue(sut.recipe.nutritionData.calories == testResult.calories, "Calories should match")
        XCTAssertTrue(sut.recipe.nutritionData.protein == testResult.protein, "Calories should match")
        XCTAssertTrue(sut.recipe.nutritionData.fat == testResult.fat, "Calories should match")
        XCTAssertTrue(sut.recipe.nutritionData.carb == testResult.carb, "Calories should match")
    }

}

//MARK: TEST CALCULATING TOTAL COOKING TIME
extension RecipeViewModelTests {
    
    func testCalculatingTotalCookingTime_whenTimeCookingInMinutesChanges() {
        sut.timeCookingInMinutes = String(10)
        XCTAssertTrue(sut.totalTimeCookingInMinutes == 10, "Total cooking time should be equal to 10, but is equal to \(sut.totalTimeCookingInMinutes)")
    }
    
    func testCalculatingTotalCookingTime_whenTimePreparingInMinutesChanges() {
        sut.timePreparingInMinutes = String(10)
        XCTAssertTrue(sut.totalTimeCookingInMinutes == 10, "Total cooking time should be equal to 10, but is equal to \(sut.totalTimeCookingInMinutes)")
    }
    
    func testCalculatingTotalCookingTime_whenTimeWaitingInMinutesChanges() {
        sut.timeWaitingInMinutes = String(10)
        XCTAssertTrue(sut.totalTimeCookingInMinutes == 10, "Total cooking time should be equal to 10, but is equal to \(sut.totalTimeCookingInMinutes)")
    }
    
}
