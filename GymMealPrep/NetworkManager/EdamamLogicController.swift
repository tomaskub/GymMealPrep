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
}
