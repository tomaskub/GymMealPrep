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
    
    func getIngredients(for ingredient: String) -> AnyPublisher<[Ingredient], Error> {
        let endpoint = EdamamParserEndpoint.ingredient(searchFor: ingredient)
        return networkController.get(type: EdamamParserResponse.self, url: endpoint.url, headers: [:])
            .map { response in
                var mapResult = [Ingredient]()
                for hint in response.hints {
                    let food = Food(name: hint.food.label)
                    let nutrients = Nutrition(fromEdamam: hint.food.nutrients)
                    
                    let ingredient = Ingredient(
                        food: food,
                        quantity: 1,
                        unitOfMeasure: hint.measures.first?.label ?? "Unknown",
                        nutritionData: nutrients
                    )
                    mapResult.append(ingredient)
                }
                return mapResult
            }
            .eraseToAnyPublisher()
        
    }
    
}

fileprivate extension Nutrition {
    init(fromEdamam nutrient: EdamamParserResponse.Nutrients) {
        self.init(calories: Float(nutrient.enercKcal), carb: Float(nutrient.chocdf), fat: Float(nutrient.fat), protein: Float(nutrient.procnt))
    }
}
