//
//  RequestProtocol.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/14/23.
//

import Foundation

protocol Request {
    
    var path: String { get }
    
    var headers: [String: String]? { get }
    var params: [String: Any] { get }
    
    var urlParams: [String: String?] { get }
    
    var addAuthToken: Bool { get }
    
    var requestType: RequestType { get }
    
}

enum NetworkEnvironment: String {
    case edamamParser = "https://api.edamam.com/api/food-database/v2/parser"
    case edamamNutrients = "https://api.edamam.com/api/food-database/v2/nutrients"
}

enum RequestType: String {
    case get
    case post
    case put
    case patch
    case delete
}

extension Request {
    var headers: [String : String]? {
        return nil
    }
    
    func create(for environment: NetworkEnvironment) -> URLRequest {
        guard let url = URL(string: environment.rawValue + path) else { fatalError("Failed to generate url in create(for environment:") }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = requestType.rawValue.uppercased()
        return request
    }
}
