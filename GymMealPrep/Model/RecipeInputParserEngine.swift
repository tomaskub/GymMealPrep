//
//  RecipeInputParser.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 15/08/2023.
//

import Foundation

enum RecipeInputParserEngineError: Error {
    case emptyInput
    case couldNotDetermineSymbol
}

enum ListDelimiterType: Equatable {
    case simple(CharacterSet)
    case iteratedSimple(CharacterSet)
}

class RecipeInputParserEngine: ParserEngine {
    
    /// Parse list from input of the parser into array of strings with list delimiters, whitespaces and new lines removed
    func parseList(from input: String) throws -> [String] {
        guard !input.isEmpty else { throw RecipeInputParserEngineError.emptyInput }
        var result = [String]()
        do {
            let delimiterType = try findListSymbol(in: input)
            switch delimiterType {
            case .simple(let characterSet):
                let localScanner = Scanner(string: input)
                while !localScanner.isAtEnd {
                    if let newLine = scanNewLine(scanner: localScanner) {
                        let processedLine = newLine.trimmingPrefix { character in
                            for unicodeScalar in character.unicodeScalars {
                                if characterSet.contains(unicodeScalar) {
                                    return true
                                }
                            }
                            return false
                        }
                        result.append(processedLine.trimmingCharacters(in: .whitespacesAndNewlines))
                    }
                }
            case .iteratedSimple(let characterSet):
                let trimmingCharactersSet = CharacterSet.whitespacesAndNewlines.union(CharacterSet.punctuationCharacters)
                let localScanner = Scanner(string: input)
                while !localScanner.isAtEnd {
                    if let newLine = scanNewLine(scanner: localScanner) {
                        let processedLine = newLine.trimmingPrefix { character in
                            for unicodeScalar in character.unicodeScalars {
                                if characterSet.contains(unicodeScalar) {
                                    return true
                                }
                            }
                            return false
                        }
                        if processedLine == newLine {
                            if let lastElement = result.last {
                                let replacingElement = lastElement + processedLine
                                _ = result.removeLast()
                                result.append(replacingElement.trimmingCharacters(in: trimmingCharactersSet))
                            }
                        } else {
                            result.append(processedLine.trimmingCharacters(in: trimmingCharactersSet))
                        }
                    }
                }
            }
            // assume there is no delimiter, seperate by newlines
        } catch RecipeInputParserEngineError.couldNotDetermineSymbol {
            let scanner = Scanner(string: input)
            scanner.charactersToBeSkipped = nil
            while !scanner.isAtEnd {
                if let newLine = scanNewLine(scanner: scanner) {
                    result.append(newLine.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
                }
            }
        }
        result.removeAll(where: { $0.isEmpty })
        return result
    }
    
}
