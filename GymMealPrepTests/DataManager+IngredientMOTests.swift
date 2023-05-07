//
//  DataManager+IngredientMOTests.swift
//  GymMealPrepTests
//
//  Created by Tomasz Kubiak on 5/7/23.
//

import XCTest
@testable import GymMealPrep

final class DataManagerIngredientMOTests: XCTestCase {

    var sut: DataManager!
    override func setUp() {
        sut = DataManager.testing
    }

    override func tearDown() {
        sut = nil
    }

    func testUpdateAndSave_whenNoIngredientExists() throws {
        let ingredient = Ingredient(food: Food(name: "TestFood"), quantity: 1, unitOfMeasure: "Test UOM", nutritionData: Nutrition(calories: 0, carb: 0, fat: 0, protein: 0))
        sut.updateAndSave(ingredient: ingredient)
        
        let request = IngredientMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", ingredient.id as CVarArg)
        request.fetchLimit = 1
        do {
            let result = try sut.managedContext.fetch(request)
            let first = try XCTUnwrap(result.first, "There should be a first in results array")
            XCTAssertTrue(first.id == ingredient.id, "The ID of retrived ingredientMO should be equal to id of ingredient ")
        } catch {
            XCTFail("Error while fetching: \(error.localizedDescription)")
        }
    }

    func testUpdateAndSave_whenIngredientExists() throws {
        let ingredient = Ingredient(food: Food(name: "TestFood"), quantity: 1, unitOfMeasure: "Test UOM", nutritionData: Nutrition(calories: 0, carb: 0, fat: 0, protein: 0))
        sut.updateAndSave(ingredient: ingredient)
        
        let newIngredient = Ingredient(id: ingredient.id,food: Food(name: "TestFood"), quantity: 1, unitOfMeasure: "Test UOM 2", nutritionData: Nutrition(calories: 0, carb: 0, fat: 0, protein: 0))
        sut.updateAndSave(ingredient: newIngredient)
        
        let request = IngredientMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", ingredient.id as CVarArg)
        request.fetchLimit = 1
        do {
            let result = try sut.managedContext.fetch(request)
            let first = try XCTUnwrap(result.first, "There should be a first in results array")
            XCTAssertTrue(first.unitOfMeasure == newIngredient.unitOfMeasure, "The UOM of retrived ingredientMO should be equal to UOM of newIngredient")
        } catch {
            XCTFail("Error while fetching: \(error.localizedDescription)")
        }
    }
    func testDeleteIngredient_whenIngredientExists() {
        let ingredient = Ingredient(food: Food(name: "TestFood"), quantity: 1, unitOfMeasure: "Test UOM", nutritionData: Nutrition(calories: 0, carb: 0, fat: 0, protein: 0))
        sut.updateAndSave(ingredient: ingredient)
        
        sut.delete(ingredient: ingredient)
        
        let request = IngredientMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", ingredient.id as CVarArg)
        request.fetchLimit = 1
        do {
            let result = try sut.managedContext.fetch(request)
            XCTAssertTrue(result.isEmpty, "The resulting array should be empty")
        } catch {
            XCTFail("Error while fetching: \(error.localizedDescription)")
        }
    }
}
