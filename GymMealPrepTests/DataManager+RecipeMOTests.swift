//
//  DataManager+RecipeMOTestes.swift
//  GymMealPrepTests
//
//  Created by Tomasz Kubiak on 5/8/23.
//

import XCTest
@testable import GymMealPrep

final class DataManagerRecipeMOTests: XCTestCase {

    var sut: DataManager!
    
    override func setUp() {
        sut = DataManager.testing
    }
    
    override func tearDown() {
        sut = nil
    }
    
    /// Test function updateAndSave, with condition that a new Instruction is added
    func testUpdateAndSave_whenNoRecipeExist() throws {
        // define test ingredients
        let ingredient = Ingredient(food: Food(name: "Test food"), quantity: 2, unitOfMeasure: "cups", nutritionData: Nutrition.zero)
        let instruction = Instruction(step: 1, text: "Test instruction")
        let tag = Tag(text: "Test tag")
        let recipe = Recipe(id: UUID(), name: "Test Recipe", servings: 4, timeCookingInMinutes: 30, timePreparingInMinutes: 15, timeWaitingInMinutes: 0, ingredients: [ingredient], instructions: [instruction], tags: [tag])
        
        sut.updateAndSave(recipe: recipe)
        
        let request = RecipeMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", recipe.id as CVarArg)
        request.fetchLimit = 1
        do {
            let result = try sut.managedContext.fetch(request)
            //check if results are retrieved
            let first = try XCTUnwrap(result.first, "There should be recipe retrived")
            //check if right results is retrived
            XCTAssertTrue(first.name == recipe.name, "Name in retrieved recipe should be equal to name in initial recipe")
            // check if right ingredient is present
            let ingredients = try XCTUnwrap(first.ingredients)
            let ingredientsMO = ingredients.compactMap({$0 as? IngredientMO})
            XCTAssertTrue(ingredientsMO.contains(where: {$0.id == ingredient.id}), "There should be ingredient with matching id")
        } catch {
            XCTFail("Error while fetching: \(error.localizedDescription)")
        }
    }
    
    func testUpdateAndSave_whenRecipeExistis_whenTagRemoved() throws {
        let ingredient = Ingredient(food: Food(name: "Test food"), quantity: 2, unitOfMeasure: "cups", nutritionData: Nutrition.zero)
        let instruction = Instruction(step: 1, text: "Test instruction")
        let tag = Tag(text: "Test tag")
        let recipe = Recipe(id: UUID(), name: "Test Recipe", servings: 4, timeCookingInMinutes: 30, timePreparingInMinutes: 15, timeWaitingInMinutes: 0, ingredients: [ingredient], instructions: [instruction], tags: [tag])
        sut.updateAndSave(recipe: recipe)
        
        var newRecipe = recipe
        newRecipe.name = "Recipe name changed"
        newRecipe.tags = []
        sut.updateAndSave(recipe: newRecipe)
        
        let request = RecipeMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", recipe.id as CVarArg)
        request.fetchLimit = 1
        
        do {
            let result = try sut.managedContext.fetch(request)
            //check if results are retrieved
            let first = try XCTUnwrap(result.first, "There should be recipe retrived")
            //check if right results is retrived
            XCTAssertTrue(first.name == newRecipe.name, "Name in retrieved recipe should be equal to name in newRecipe")
            // check if right ingredient is present
            let tags = try XCTUnwrap(first.tags)
            let tagsMO = tags.compactMap({$0 as? TagMO})
            XCTAssertFalse(tagsMO.contains(where: {$0.id == tag.id}), "There should not be tag with matching id")
        } catch {
            XCTFail("Error while fetching: \(error.localizedDescription)")
        }
    }
    
    func testUpdateAndSave_whenRecipeExistis_whenInstructionRemoved() throws {
        let ingredient = Ingredient(food: Food(name: "Test food"), quantity: 2, unitOfMeasure: "cups", nutritionData: Nutrition.zero)
        let instruction = Instruction(step: 1, text: "Test instruction")
        let tag = Tag(text: "Test tag")
        let recipe = Recipe(id: UUID(), name: "Test Recipe", servings: 4, timeCookingInMinutes: 30, timePreparingInMinutes: 15, timeWaitingInMinutes: 0, ingredients: [ingredient], instructions: [instruction], tags: [tag])
        sut.updateAndSave(recipe: recipe)
        
        var newRecipe = recipe
        newRecipe.name = "Recipe name changed"
        newRecipe.instructions = []
        sut.updateAndSave(recipe: newRecipe)
        
        let request = RecipeMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", recipe.id as CVarArg)
        request.fetchLimit = 1
        
        do {
            let result = try sut.managedContext.fetch(request)
            //check if results are retrieved
            let first = try XCTUnwrap(result.first, "There should be recipe retrived")
            //check if right results is retrived
            XCTAssertTrue(first.name == newRecipe.name, "Name in retrieved recipe should be equal to name in newRecipe")
            // check if right ingredient is present
            let instructions = try XCTUnwrap(first.instructions)
            let instructionsMO = instructions.compactMap({$0 as? InstructionMO})
            XCTAssertFalse(instructionsMO.contains(where: {$0.id == instruction.id}), "There should not be instruction with matching id")
        } catch {
            XCTFail("Error while fetching: \(error.localizedDescription)")
        }
    }
    
    func testUpdateAndSave_whenRecipeExistis_whenIngredientRemoved() throws {
        let ingredient = Ingredient(food: Food(name: "Test food"), quantity: 2, unitOfMeasure: "cups", nutritionData: Nutrition.zero)
        let instruction = Instruction(step: 1, text: "Test instruction")
        let tag = Tag(text: "Test tag")
        let recipe = Recipe(id: UUID(), name: "Test Recipe", servings: 4, timeCookingInMinutes: 30, timePreparingInMinutes: 15, timeWaitingInMinutes: 0, ingredients: [ingredient], instructions: [instruction], tags: [tag])
        sut.updateAndSave(recipe: recipe)
        
        var newRecipe = recipe
        newRecipe.name = "Recipe name changed"
        newRecipe.ingredients = []
        sut.updateAndSave(recipe: newRecipe)
        
        let request = RecipeMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", recipe.id as CVarArg)
        request.fetchLimit = 1
        
        do {
            let result = try sut.managedContext.fetch(request)
            //check if results are retrieved
            let first = try XCTUnwrap(result.first, "There should be recipe retrived")
            //check if right results is retrived
            XCTAssertTrue(first.name == newRecipe.name, "Name in retrieved recipe should be equal to name in newRecipe")
            // check if right ingredient is present
            let ingredients = try XCTUnwrap(first.ingredients)
            let ingredientsMO = ingredients.compactMap({$0 as? IngredientMO})
            XCTAssertFalse(ingredientsMO.contains(where: {$0.id == ingredient.id}), "There should not be instruction with matching id")
        } catch {
            XCTFail("Error while fetching: \(error.localizedDescription)")
        }
    }
    func testDelete_WhenRecipeExists() {
        let ingredient = Ingredient(food: Food(name: "Test food"), quantity: 2, unitOfMeasure: "cups", nutritionData: Nutrition.zero)
        let instruction = Instruction(step: 1, text: "Test instruction")
        let tag = Tag(text: "Test tag")
        let recipe = Recipe(id: UUID(), name: "Test Recipe", servings: 4, timeCookingInMinutes: 30, timePreparingInMinutes: 15, timeWaitingInMinutes: 0, ingredients: [ingredient], instructions: [instruction], tags: [tag])
        
        sut.updateAndSave(recipe: recipe)
        
        sut.delete(recipe: recipe)
        let request = RecipeMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", recipe.id as CVarArg)
        request.fetchLimit = 1
        do {
            let result = try sut.managedContext.fetch(request)
            XCTAssert(result.isEmpty, "Result array should be empty")
        } catch {
            XCTFail("Error while fetching: \(error.localizedDescription)")
        }
    }
    
    func testDelete_WhenNoRecipeExists() {
        let recipe = Recipe(id: UUID(), name: "Test Recipe", servings: 4, timeCookingInMinutes: 30, timePreparingInMinutes: 15, timeWaitingInMinutes: 0, ingredients: [], instructions: [], tags: [])
        sut.delete(recipe: recipe)
        let request = RecipeMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", recipe.id as CVarArg)
        request.fetchLimit = 1
        do {
            let result = try sut.managedContext.fetch(request)
            XCTAssert(result.isEmpty, "Result array should be empty")
        } catch {
            XCTFail("Error while fetching: \(error.localizedDescription)")
        }
    }
    
}
