//
//  WebsiteRecipeParserEngine.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 14/08/2023.
//

import Foundation

final class WebsiteRecipeParserEngine {
    private let scanner: Scanner
    private let listCharacters: CharacterSet
    private let reduceClosure: (String, String) -> String = { $0.isEmpty ? $1 : "\($0)\n\($1)" }
    
    init(source: Data,
         charactersToBeSkipped: CharacterSet = .whitespacesAndNewlines,
         listCharacters: CharacterSet = CharacterSet(charactersIn: "•")) throws {
        let attributedString = try NSAttributedString(data: source,
                                                    options: [.documentType: NSAttributedString.DocumentType.html,
                                                              .characterEncoding: String.Encoding.utf8.rawValue],
                                                    documentAttributes: nil)
        self.scanner = Scanner.init(string: attributedString.string)
        self.scanner.charactersToBeSkipped = charactersToBeSkipped
        self.listCharacters = listCharacters
    }
    
    func scanForRecipeData() -> (String, String) {
        let (first, second): ([String], [String]) = scanForRecipeData()
        return (first.reduce("", reduceClosure), second.reduce("", reduceClosure))
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


