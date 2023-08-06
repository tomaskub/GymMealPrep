//
//  CaseIterable+Extensions.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 8/6/23.
//

import Foundation

extension CaseIterable where Self: Equatable {
    
    ///Returns the next enum case or the first one in case it was called on last one
    func next() -> Self {
        let all = Self.allCases
        let index = all.firstIndex(of: self)!
        let next = all.index(after: index)
        return all[next == all.endIndex ? all.startIndex : next]
    }
    
    ///Returns the previous enum case or the last one in case it was called on the first one
    func previous() -> Self {
        let all = Self.allCases.reversed()
        let index = all.firstIndex(of: self)!
        let next = all.index(after: index)
        return all[next == all.endIndex ? all.startIndex : next]
    }
}
