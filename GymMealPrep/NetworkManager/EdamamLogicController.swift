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
    
    /// get ingredients for a given string
    func getIngredients(for: String) -> AnyPublisher<EdamamParserResponse, Error>
    
}

final class EdamamLogicController: EdamamLogicControllerProtocol {
    let networkController: Network
    
    init(networkController: Network) {
        self.networkController = networkController
    }
    
    func getIngredients(for ingredient: String) -> AnyPublisher<EdamamParserResponse, Error> {
        let endpoint = EdamamParserEndpoint.ingredient(searchFor: ingredient)
        print(endpoint.url.description)
        return networkController.get(type: EdamamParserResponse.self, url: endpoint.url, headers: [:])
    }
    
    func getIngredients(for ingredient: String) -> AnyPublisher<[[Ingredient]], Error> {
        let endpoint = EdamamParserEndpoint.ingredient(searchFor: ingredient)
        return networkController.get(type: EdamamParserResponse.self, url: endpoint.url, headers: [:])
            //TODO: EXTRACT MAP TO SEPERATE FUNCTION
            .map { [weak self] response in
                
                guard let self else { return [[]] }
                let result  = self.transformParserResponse(response.hints)
                return result
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