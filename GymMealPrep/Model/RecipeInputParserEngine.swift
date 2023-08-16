//
//  RecipeInputParser.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 15/08/2023.
//

import Foundation

class RecipeInputParserEngine {
    private let input: String
    
    init(input: String) {
        self.input = input
    }
    
    /// Return character used for list starting symbol if any
    func findListSymbol() -> Character? {
        guard !input.isEmpty else { return nil }
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
            return nil
        }
    }
}
