//
//  EdamamNetwork+Route.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/14/23.
//

import Foundation

struct EdamamParserNetwork: Network {
    var decoder: JSONDecoder = JSONDecoder()
    var environment: NetworkEnvironment = .edamamParser
}

enum EdamamParserRoute {
    case parser
}

//extension EdamamParserRoute: NetworkRoute {
//    var params: [String : Any]? {
//        nil
//    }
//    
//    var urlParams: [String : String?] {
//        [:]
//    }
//    
//    var addAuthToken: Bool {
//        true
//    }
//    
//    var requestType: NetworkRequestType {
//        .get
//    }
//    
//    var path: String {
//        switch self {
//        case .parser:
//            return ""
//        }
//    }
//}
