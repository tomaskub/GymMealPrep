//
//  WebLinkLogicController.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 13/08/2023.
//

import Foundation
import Combine

final class WebLinkLogicController {
    let networkController: Network
    
    init(networkController: Network) {
        self.networkController = networkController
    }
    
    func getData(for link: String) -> AnyPublisher<Data, Error> {
        guard let url = URL(string: link) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return networkController.getData(url: url)
    }
}
