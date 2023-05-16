//
//  Endpoint.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/16/23.
//

import Foundation

struct Endpoint: EndpointProtocol {
    var path : String // path to the correct api like nutrients or parser
    var queryItems: [URLQueryItem] = []
    
    
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.edamam.com"
        components.path = "/api/food-database/v2/" + path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            
            preconditionFailure("Invalid url components: \(components)")
        }
        return url
    }
    
    var headers: [String: Any] {
        // check if app id and api key can go here
        return [:]
    }
    
    static func ingredient(searchFor: String) -> Self {
        return Endpoint(path: "parser", queryItems: [
            URLQueryItem(name: "app_id", value: EdamamAPIAuth.apiID),
            URLQueryItem(name: "app_key", value: EdamamAPIAuth.apiKey),
            URLQueryItem(name: "ingr", value: searchFor),
            URLQueryItem(name: "nutrition-type", value: "cooking")
        ])
    }
}

struct EdamamAPIAuth {
    fileprivate static var apiKey: String {
        
        guard let filePath = Bundle.main.path(forResource: "Edamam-Info", ofType: "plist") else {
            fatalError("Could not find path to Edamam-Info.plist")
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("Could not find key 'API_KEY' in 'EDAMAM-INFO.PLIST'.")
        }
        return value
        
    }
    
    fileprivate static var apiID: String {
        
        guard let filePath = Bundle.main.path(forResource: "Edamam-Info", ofType: "plist") else {
            fatalError("Could not find path to Edamam-Info.plist")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_ID") as? String else {
            fatalError("Could not find key 'API_KEY' in 'EDAMAM-INFO.PLIST'.")
        }
        return value
        
    }
}
