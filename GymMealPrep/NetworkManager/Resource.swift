//
//  Resource.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/14/23.
//

import SwiftUI

enum Resource<T> {
    case loading
    case success(T)
    case error(Error)
}

extension Resource {
    
    var loading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
    
    var error: Error? {
        switch self {
        case .error(let error):
            return error
        default:
            return nil
        }
    }
    
    var value: T? {
        switch self {
        case .success(let value):
            return value
        default:
            return nil
        }
    }
}
extension Resource {
    //transforming resource T to resource S
    func transform<S>(_ t: @escaping (T) -> S) -> Resource<S> {
        switch self {
        case .loading:
            return .loading
        case .error(let error):
            return .error(error)
        case .success(let value):
            return .success(t(value))   
        }
    }
}
