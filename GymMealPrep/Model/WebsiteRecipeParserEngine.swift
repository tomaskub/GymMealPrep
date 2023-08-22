//
//  WebsiteRecipeParserEngine.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 14/08/2023.
//

import Foundation

final class WebsiteRecipeParserEngine: ParserEngine {
    private let reduceClosure: (String, String) -> String = { $0.isEmpty ? $1 : "\($0)\n\($1)" }
    
    private let listCharacters: CharacterSet
    private let charactersToBeSkipped: CharacterSet
    private let source: Data
    
    init(source: Data,
         charactersToBeSkipped: CharacterSet = .whitespacesAndNewlines,
         listCharacters: CharacterSet = CharacterSet(charactersIn: "•")) {
        self.source = source
        self.charactersToBeSkipped = charactersToBeSkipped
        self.listCharacters = listCharacters
    }
    
    func scanForRecipeData() throws -> (String, String) {
        let result = try scanForListsData(listHeadlines: ["ingredients", "instructions"])
        guard let first = result["ingredients"], let second = result["instructions"] else {
            fatalError()
        }
        return (first.reduce("", reduceClosure), second.reduce("", reduceClosure))
    }
    
    func scanForListsData(listHeadlines: [String]) throws -> [String : [String]] {
        let attributedString = try NSAttributedString(data: source,
                                                    options: [.documentType: NSAttributedString.DocumentType.html,
                                                              .characterEncoding: String.Encoding.utf8.rawValue],
                                                    documentAttributes: nil)
        let scanner = Scanner(string: attributedString.string)
        var targetHeadlines: [String] = listHeadlines
        var scannedItems = [String : [String]]()
        for headline in targetHeadlines {
            scannedItems.updateValue([String](), forKey: headline)
        }
        while !scanner.isAtEnd {
            if var newLine = scanNewLine(scanner: scanner) {
                for targetHeadline in targetHeadlines {
                    if newLine.lowercased().hasPrefix(targetHeadline) {
                        var temp = [String]()
                        scanForListItems(&newLine, scanner: scanner, appendNewLinesTo: &temp)
                        scannedItems.updateValue(temp, forKey: targetHeadline)
                        targetHeadlines.removeAll(where: {$0 == targetHeadline})
                    }
                }
            }
            if scannedItems.values.allSatisfy({ !$0.isEmpty }) {
                break
            }
        }
        return scannedItems
    }
    
    private func scanForListItems(_ currentLine: inout String, scanner: Scanner, appendNewLinesTo target: inout [String]) {
        while !scanner.isAtEnd {
            if let newLine = scanNewLine(scanner: scanner) {
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
    
}

fileprivate extension CharacterSet {
    func containsUnicodeScalars(of c: Character) -> Bool {
        return c.unicodeScalars.allSatisfy(contains(_:))
    }
}


