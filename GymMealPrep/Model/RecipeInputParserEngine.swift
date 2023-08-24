//
//  RecipeInputParser.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 15/08/2023.
//

import Foundation

enum ListDelimiterType: Hashable {
    case simple(CharacterSet)
    case iteratedSimple(CharacterSet)
}

class RecipeInputParserEngine: ParserEngine {
    
    /// Parse list from input of the parser into array of strings with list delimiters, whitespaces and new lines removed
    func parseList(from input: String) throws -> [String] {
        guard !input.isEmpty else { throw ParserEngineError.emptyInput }
        var result = [String]()
        
        do {
            let delimiterType = try findListSymbol(in: input)
            switch delimiterType {
            case .simple(let characterSet):
                result = parseListWithSimpleDelimiter(input: input, characterSet: characterSet)
            case .iteratedSimple(let characterSet):
                result = parseListWithIteratedDelimiter(input: input, characterSet: characterSet)
            }
        } catch ParserEngineError.couldNotDetermineSymbol {
            result = parseListWithNoDelimiter(input: input)
        }
        
        result.removeAll(where: { $0.isEmpty })
        return result
    }
    
    private func parseListWithSimpleDelimiter(input: String, characterSet: CharacterSet) -> [String] {
        var result = [String]()
        let localScanner = Scanner(string: input)
        let trimmingPrefixClosure = createTrimmingClosure(trimmingCharSet: characterSet)
        
        while !localScanner.isAtEnd {
            if let newLine = scanNewLine(scanner: localScanner) {
                let processedLine = newLine.trimmingPrefix(while: trimmingPrefixClosure)
                result.append(processedLine.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
        return result
    }
    
    private func parseListWithIteratedDelimiter(input: String, characterSet: CharacterSet) -> [String] {
        var result = [String]()
        let localScanner = Scanner(string: input)
        let trimingPrefixClosure = createTrimmingClosure(trimmingCharSet: characterSet)
        let trimmingCharactersSet: CharacterSet = .whitespacesAndNewlines.union(.punctuationCharacters)
        
        while !localScanner.isAtEnd {
            if let newLine = scanNewLine(scanner: localScanner) {
                let processedLine = newLine.trimmingPrefix(while: trimingPrefixClosure)
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
        return result
    }
    
    private func parseListWithNoDelimiter(input: String) -> [String] {
        var result = [String]()
        let scanner = Scanner(string: input)
        scanner.charactersToBeSkipped = nil
        while !scanner.isAtEnd {
            if let newLine = scanNewLine(scanner: scanner) {
                result.append(newLine.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
            }
        }
        return result
    }
    
    private func createTrimmingClosure(trimmingCharSet: CharacterSet) -> ((Character) -> Bool) {
        let result: (Character) -> Bool = { character in
            for unicodeScalar in character.unicodeScalars {
                if trimmingCharSet.contains(unicodeScalar) {
                    return true
                }
            }
            return false
        }
        return result
    }
}
