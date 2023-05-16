//
//  Network.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/14/23.
//
import Foundation
import Combine

/// Protocol with requirements for a network controller responsible for retrieving the data over network
protocol Network: AnyObject {
    
    typealias Headers = [String: Any]
    
    func get<T>(type: T.Type, url: URL, headers: Headers) -> AnyPublisher<T, Error> where T: Decodable
    
}
