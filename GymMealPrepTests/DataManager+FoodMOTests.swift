//
//  DataManager+FoodMOTests.swift
//  GymMealPrepTests
//
//  Created by Tomasz Kubiak on 5/7/23.
//

import XCTest
@testable import GymMealPrep

final class DataManagerFoodMOTests: XCTestCase {

    var sut: DataManager!
    override func setUp() {
        sut = DataManager.testing
    }

    override func tearDown() {
        sut = nil
    }
    
    /// Test function updateAndSave, with condition that a new tag is added
    func testUpdateAndSave_whenNoFoodExist() {
        let food = Food(name: "Test Food")
        sut.updateAndSave(food: food)
        
        let request = FoodMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", food.id as CVarArg)
        request.fetchLimit = 1
        do {
            let result = try sut.managedContext.fetch(request)
            XCTAssertTrue(result[0].name == food.name, "Name in FoodMO should be equal to name in food")
        } catch {
            XCTFail("Error while fetching: \(error.localizedDescription)")
        }
    }
    
    func testUpdateAndSave_whenTagExist() {
        let food = Food(name: "Test food")
        sut.updateAndSave(food: food)
        
        let newFood = Food(id: food.id, name: "Test food 2")
        sut.updateAndSave(food: newFood)
        
        let request = FoodMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", food.id as CVarArg)
        request.fetchLimit = 1
        do {
            let result = try sut.managedContext.fetch(request)
            XCTAssertTrue(result[0].name == newFood.name, "Name in retrieved foodMO should be equal to new food name")
        } catch {
            XCTFail("Error while fetching: \(error.localizedDescription)")
        }
    }
    
    func testDeleteTag_whenNoTagExist() {
        let food = Food(name: "Test food")

        sut.delete(food: food)
        
        let request = FoodMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", food.id as CVarArg)
        request.fetchLimit = 1
        do {
            let result = try sut.managedContext.fetch(request)
            XCTAssertTrue(result.isEmpty, "The resulting array should be empty")
        } catch {
            XCTFail("Error while fetching: \(error.localizedDescription)")
        }
    }
    
    func testDeleteTag_whenTagExists() {
        let food = Food(name: "Test food")
        sut.updateAndSave(food: food)
        
        sut.delete(food: food)
        
        let request = FoodMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", food.id as CVarArg)
        request.fetchLimit = 1
        do {
            let result = try sut.managedContext.fetch(request)
            XCTAssertTrue(result.isEmpty, "The resulting array should be empty")
        } catch {
            XCTFail("Error while fetching: \(error.localizedDescription)")
        }
    }
    
    func testAddToIngredient_whenNoFoodExist() throws {
        let ingredientMO = IngredientMO(context: sut.managedContext, calories: 100, carbs: 100, fat: 100, protein: 100, quantity: 2.0, unitOfMeasure: "test")
//        let food = Food(name: "test food")
        let food = FoodMO(context: sut.managedContext, name: "testFood")
        ingredientMO.food = food
//        sut.addToIngredients(food: food, to: ingredientMO)
        sut.saveContext()
        
        let request = FoodMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", food.id as CVarArg)
        request.fetchLimit = 1
        do {
            let result = try sut.managedContext.fetch(request)
            let resultFood = try XCTUnwrap(result.first, "There should be foodMO retrieved")
            let ingredients = try XCTUnwrap(resultFood.ingredients, "There should be a set of ingredients in retrived foodMO")
            
            
            XCTAssertTrue(ingredients.allObjects.compactMap({$0 as? IngredientMO}).contains(where: { $0.id == ingredientMO.id }), "The resulting array should have an object with ingredient id")
        } catch {
            XCTFail("Error while fetching: \(error.localizedDescription)")
        }
    }
    func testAddToIngredient_whenFoodExist() throws {
        let food = Food(name: "test food")
        sut.updateAndSave(food: food)
        
        let ingredientMO = IngredientMO(context: sut.managedContext, calories: 100, carbs: 100, fat: 100, protein: 100, quantity: 2.0, unitOfMeasure: "test")
    
        sut.addToIngredients(food: food, to: ingredientMO)
        
        sut.saveContext()
        
        let request = FoodMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", food.id as CVarArg)
        request.fetchLimit = 1
        do {
            let result = try sut.managedContext.fetch(request)
            let resultFood = try XCTUnwrap(result.first, "There should be foodMO retrieved")
            let ingredients = try XCTUnwrap(resultFood.ingredients, "There should be a set of ingredients in retrived foodMO")
            
            
            XCTAssertTrue(ingredients.allObjects.compactMap({$0 as? IngredientMO}).contains(where: { $0.id == ingredientMO.id }), "The resulting array should have an object with ingredient id")
        } catch {
            XCTFail("Error while fetching: \(error.localizedDescription)")
        }
    }
}
