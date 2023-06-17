//
//  EdamamLogicControllerProtocol.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/16/23.
//

import Foundation
import Combine

protocol EdamamLogicControllerProtocol: AnyObject {
    var networkController: Network { get }
    
    /// get ingredients for a given string in form of EdamamParserResponse
    func getParserResponse(for: String) -> AnyPublisher<EdamamParserResponse, Error>
    
    /// get ingredients for a given string in form of Array of ingredients objects
    func getIngredients(for ingredient: String) -> AnyPublisher<[[Ingredient]], Error>
    
    func getIngredientsWithParsed(for ingredient: String) -> AnyPublisher<([[Ingredient]], Ingredient?),Error> 
    
}

final class EdamamLogicController: EdamamLogicControllerProtocol {
    let networkController: Network
    
    init(networkController: Network) {
        self.networkController = networkController
    }
    
    func getParserResponse(for ingredient: String) -> AnyPublisher<EdamamParserResponse, Error> {
        let endpoint = EdamamParserEndpoint.ingredient(searchFor: ingredient)
        print(endpoint.url.description)
        return networkController.get(type: EdamamParserResponse.self, url: endpoint.url, headers: [:])
    }
    
    
    /// Publisher getting ingredients from Edamam API
    /// - Parameter ingredient: input text for Edamam parser
    /// - Returns: A publisher with an array of Ingredients arrays, grouped by food type of the ingredient
    func getIngredients(for ingredient: String) -> AnyPublisher<[[Ingredient]], Error> {
        let endpoint = EdamamParserEndpoint.ingredient(searchFor: ingredient)
        return networkController.get(type: EdamamParserResponse.self, url: endpoint.url, headers: [:])
            .map { [weak self] response in
                guard let self else { return [[]] }
                let result  = self.transformParserResponse(response.hints)
                return result
            }
            .eraseToAnyPublisher()
    }
    
    func getIngredientsWithParsed(for ingredient: String) -> AnyPublisher<([[Ingredient]], Ingredient?),Error> {
        let endpoint = EdamamParserEndpoint.ingredient(searchFor: ingredient)
        return networkController.get(type: EdamamParserResponse.self, url: endpoint.url, headers: [:])
            .map { [weak self] response in
                guard let self else { return ([[Ingredient]](), nil) }
                let result  = self.transformParserResponse(response.hints)
                var parsed: Ingredient?
                if let parsedResponse = response.parsed?.first {
                    let food = Food(name: parsedResponse.food.label)
                    let quantity = parsedResponse.quantity
                    let factor = (quantity ?? 100) * (parsedResponse.measure?.weight ?? 1) / 100
                    let nutrients = Nutrition(fromEdamam: parsedResponse.food.nutrients).multiplyBy(factor)
                    let uom = parsedResponse.measure?.label ?? "gram"
                    parsed = Ingredient(food: food, quantity: quantity ?? 1, unitOfMeasure: uom, nutritionData: nutrients)
                }
                return (result, parsed)
            }
            .eraseToAnyPublisher()
    }

    /// Transform hints from edamam parser response hints to an array of array of ingredients
    /// - Parameter responseHints: Hint array retrived from Edamam Parser response
    /// - Returns: An array of array of ingredients
    private func transformParserResponse(_ responseHints: [EdamamParserResponse.Hint]) -> [[Ingredient]] {
        
        var mapResult = [[Ingredient]]()
        
        for hint in responseHints {
            
            var foodResult = [Ingredient]()
            
            let food = Food(name: hint.food.label)
            let nutrients = Nutrition(fromEdamam: hint.food.nutrients)

            for measure in hint.measures {
                
                if let qualifiedMeasures = measure.qualified {
                    for qualifier in qualifiedMeasures {
                        let factor = qualifier.weight / 100 // standard nutrition is given for 100g
                        let nutritionData = nutrients.multiplyBy(factor)
                        let uom = measure.label + " (" + qualifier.qualifiers.first!.label + ")"
                        let ingredient = Ingredient(food: food, quantity: 1, unitOfMeasure: uom, nutritionData: nutritionData)
                        foodResult.append(ingredient)
                    }
                } else {
                      // measure has no qualifiers  create
                    let factor = measure.weight / 100 // standard nutrition is given for 100g
                    let nutritionData = nutrients.multiplyBy(factor)
                    let ingredient = Ingredient(
                        food: food,
                        quantity: 1,
                        unitOfMeasure: measure.label,
                        nutritionData: nutritionData
                    )
                    foodResult.append(ingredient)
                }
            }
            mapResult.append(foodResult)
        }
        return mapResult
    }
    
}

fileprivate extension Nutrition {
    init(fromEdamam nutrient: EdamamParserResponse.Nutrients) {
        self.init(calories: Float(nutrient.enercKcal ?? 0),
                  carb: Float(nutrient.carbs ?? 0),
                  fat: Float(nutrient.fat ?? 0),
                  protein: Float(nutrient.protein ?? 0))
    }
}
