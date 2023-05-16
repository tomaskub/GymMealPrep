//
//  EndpointProtocol.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/16/23.
//

import Foundation

protocol EndpointProtocol {
    
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    
    var url: URL { get }
    var headers: [String: Any] { get }
    
}
