//
//  WebsiteRecipeParserEngine.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 14/08/2023.
//

import Foundation

class WebsiteRecipeParserEngine {
    private let scanner: Scanner
    private let listCharacters: CharacterSet
    
    
    init(source: String,
         charactersToBeSkipped: CharacterSet = .whitespacesAndNewlines,
         listCharacters: CharacterSet = CharacterSet(charactersIn: "•")) {
        self.scanner = Scanner.init(string: source)
        self.scanner.charactersToBeSkipped = charactersToBeSkipped
        self.listCharacters = listCharacters
    }
    
    func scanForRecipeData() -> ([String], [String]) {
        var scannedIngredients = [String]()
        var scannedInstructions = [String]()
        while !scanner.isAtEnd {
            if var newLine = scanNewLine() {
                if newLine.hasPrefix("Ingredients") {
                    scanForListItems(&newLine, appendNewLinesTo: &scannedIngredients)
                }
                if newLine.hasPrefix("Instructions") {
                    scanForListItems(&newLine, appendNewLinesTo: &scannedInstructions)
                }
            }
            if !scannedIngredients.isEmpty && !scannedInstructions.isEmpty {
                break
            }
        }
        return (scannedIngredients, scannedInstructions)
    }
    
    private func scanForListItems(_ currentLine: inout String, appendNewLinesTo target: inout [String]) {
        while !scanner.isAtEnd {
            if let newLine = scanNewLine() {
                currentLine = newLine
                if let char = newLine.first {
                    if listCharacters.containsUnicodeScalars(of: char) {
                        target.append(newLine)
                    } else {
                        if !target.isEmpty {
                            break
                        }
                    }
                }
            }
        }
    }
    
    private func scanNewLine() -> String? {
        var currentChar: Character = Character("\n")
        while currentChar.isNewline && !scanner.isAtEnd {
            currentChar = scanner.scanCharacter() ?? Character("\n")
        }
        var newLine: String = String(currentChar)
        newLine.append(scanner.scanUpToCharacters(from: .newlines) ?? String())
        return newLine
    }
}

fileprivate extension CharacterSet {
    func containsUnicodeScalars(of c: Character) -> Bool {
        return c.unicodeScalars.allSatisfy(contains(_:))
    }
}


