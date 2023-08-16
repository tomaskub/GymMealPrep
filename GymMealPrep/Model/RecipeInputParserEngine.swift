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

class RecipeInputParserEngine {
    private let input: String
    
    init(input: String) {
        self.input = input
    }
    
    /// Return character used for list starting symbol if any
    func findListSymbol() throws -> Character {
        guard !input.isEmpty else { throw RecipeInputParserEngineError.emptyInput }
        let scanner = Scanner(string: input)
        scanner.charactersToBeSkipped = nil
        var result: [Character : Int] = [:]
        var lastChar = input.first!
        while !scanner.isAtEnd {
            if let currentChar = scanner.scanCharacter(){
                if !currentChar.isNewline && lastChar.isNewline {
                    let oldValue = result[currentChar] ?? 0
                    result.updateValue(oldValue + 1, forKey: currentChar)
                }
                lastChar = currentChar
            }
        }
        // find the symbol with max repetitions
        if let symbol = result.max(by: { a, b in a.value < b.value }) {
            return symbol.key
        } else {
            throw RecipeInputParserEngineError.couldNotDetermineSymbol
        }
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
