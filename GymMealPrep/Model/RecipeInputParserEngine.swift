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

enum ListDelimiterType {
    case simple(CharacterSet)
    case iteratedSimple(CharacterSet)
    case iteratedComplex(CharacterSet, CharacterSet)
}

class RecipeInputParserEngine {
    private let input: String
    
    init(input: String) {
        self.input = input
    }
    
    func parseInstructions() throws -> [String] {
        guard !input.isEmpty else { throw RecipeInputParserEngineError.emptyInput }
        var result = [String]()
        do {
            let characterSet = try findListSymbol()
            let trimmingCharacterSet = characterSet.union(.whitespacesAndNewlines)
            result = input.components(separatedBy: characterSet).map({ value in
                value.trimmingCharacters(in: trimmingCharacterSet)
            })
            result.removeAll(where: { $0.isEmpty })
        } catch RecipeInputParserEngineError.couldNotDetermineSymbol {
            let scanner = Scanner(string: input)
            while !scanner.isAtEnd {
                if let newLine = scanNewLine(scanner: scanner) {
                    result.append(newLine)
                }
            }
        }
        return result
    }
    
    func parseIngredients() throws -> [String] {
        guard !input.isEmpty else { throw RecipeInputParserEngineError.emptyInput }
        var result = [String]()
        // attempt to find delimiter
        do {
            let bullet = try findListSymbol()
            let charSet = CharacterSet(charactersIn: String("\(bullet)"))
            let trimmingCharSet = charSet.union(CharacterSet.whitespacesAndNewlines)
            result = input.components(separatedBy: charSet).map { value in
                value.trimmingCharacters(in: trimmingCharSet)
            }
            result.removeAll(where: { value in
                return value.isEmpty
            })
        } catch RecipeInputParserEngineError.couldNotDetermineSymbol {
            // parse by new lines
            let scanner = Scanner(string: input)
            while !scanner.isAtEnd {
                if let newLine = scanNewLine(scanner: scanner) {
                    result.append(newLine)
                }
            }
        }
        return result
    }
    
    //TODO: SOLVE PROBLEM WHEN MULTIPLE NUMERICAL VALUES ARE INTERPRETED AS DELIMETER WINNER
    /// Return character used for list starting symbol if any
    func findListSymbol() throws -> CharacterSet {
        // List types that should be recognized:
        
        
        guard !input.isEmpty else { throw RecipeInputParserEngineError.emptyInput }
        let scanner = Scanner(string: input)
        scanner.charactersToBeSkipped = nil
        var result: [Character : Int] = [:]
        var numberResult = [Int]()
        var letterResult = [Character]()
        var numerOfLines: Int = 1
        var lastChar = input.first!
        while !scanner.isAtEnd {
            if let currentChar = scanner.scanCharacter(){
                if !currentChar.isNewline && lastChar.isNewline {
                    numerOfLines += 1
                    // append to the array if it is a number
                    if let number = Int(String(currentChar)) {
                        numberResult.append(number)
                    }
                    if currentChar.isLetter {
                        letterResult.append(currentChar)
                    }
                    let oldValue = result[currentChar] ?? 0
                    result.updateValue(oldValue + 1, forKey: currentChar)
                }
                lastChar = currentChar
            }
        }
        // validate for numbers
        if !numberResult.isEmpty {
//            let weight: Double = Double(numberResult.count) / Double(numerOfLines)
            let orderedValues = numberResult.sorted()
            if orderedValues == numberResult {
                return CharacterSet(charactersIn: String("0123456789"))
            }
        }
        
        // find the symbol with max repetitions
        if let symbol = result.max(by: { a, b in a.value < b.value }) {
            return CharacterSet(charactersIn: String(symbol.key))
        } else {
            throw RecipeInputParserEngineError.couldNotDetermineSymbol
        }
    }
    
    private func scanNewLine(scanner: Scanner) -> String? {
        var currentChar: Character = Character("\n")
        while currentChar.isNewline && !scanner.isAtEnd {
            currentChar = scanner.scanCharacter() ?? Character("\n")
        }
        var newLine: String = String(currentChar)
        newLine.append(scanner.scanUpToCharacters(from: .newlines) ?? String())
        return newLine
    }
    
}
