//
//  ParserEngineError.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 21/08/2023.
//

import Foundation

enum ParserEngineError: Error {
    case emptyInput
    case maxLinesSetToZeroOrLess
    case couldNotDetermineSymbol
}
