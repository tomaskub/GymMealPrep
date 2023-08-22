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

    
    init(listCharacters: CharacterSet = CharacterSet(charactersIn: "•")) {
        self.listCharacters = listCharacters
    }
    
    func scanForRecipeData(in data: Data) throws -> (String, String) {
        let attributedString = try NSAttributedString(data: data,
                                                    options: [.documentType: NSAttributedString.DocumentType.html,
                                                              .characterEncoding: String.Encoding.utf8.rawValue],
                                                    documentAttributes: nil)
        let result = try scanForListsData(in: attributedString.string, listHeadlines: ["ingredients", "instructions"])
        guard let first = result["ingredients"], let second = result["instructions"] else {
            fatalError()
        }
        return (first.reduce("", reduceClosure), second.reduce("", reduceClosure))
    }
    
    func scanForListsData(in source: String, listHeadlines: [String]) throws -> [String : [String]] {
        let scanner = Scanner(string: source)
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
                        scanForListItems(&newLine, appendNewLinesTo: &temp, scanner: scanner, listDelimeterCharacters: listCharacters)
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
    
    private func scanForListItems(_ currentLine: inout String, appendNewLinesTo target: inout [String], scanner: Scanner, listDelimeterCharacters: CharacterSet) {
        while !scanner.isAtEnd {
            if let newLine = scanNewLine(scanner: scanner) {
                currentLine = newLine
                if let char = newLine.first {
                    if listDelimeterCharacters.containsUnicodeScalars(of: char) {
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


