//
//  Network.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/14/23.
//
import Foundation
import Combine

protocol Network {
    
    var decoder: JSONDecoder { get set }
    var environment: NetworkEnvironment { get set }
    
}

extension Network {
    func fetch<T: Decodable>(route: NetworkRoute) -> AnyPublisher<T, Error> {
        
        let request = route.create(for: environment)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryCompactMap { result in
                try self.decoder.decode(T.self, from: result.data)
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
