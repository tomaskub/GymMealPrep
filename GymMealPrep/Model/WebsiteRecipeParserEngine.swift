//
//  WebsiteRecipeParserEngine.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 14/08/2023.
//

import Foundation

final class WebsiteRecipeParserEngine: ParserEngine {
    private let reduceClosure: (String, String) -> String = { $0.isEmpty ? $1 : "\($0)\n\($1)" }
    var maxNewLinesInListSymbolSearch: Int = 5
    
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
        var scannedItems = [String : [String]]()
        for headline in listHeadlines {
            scannedItems.updateValue([String](), forKey: headline)
        }
        while !scanner.isAtEnd {
            if var newLine = scanNewLine(scanner: scanner) {
                for listHeadline in listHeadlines {
                    if newLine.lowercased().hasPrefix(listHeadline) {
                        var temp = [String]()
                        do {
                            let listSubString = scanner.returnNotScannedString()
                            let delimiter = try findListSymbol(in: listSubString, maximumScannedLines: maxNewLinesInListSymbolSearch)
                            switch delimiter {
                            case .simple(let characterSet):
                                scanForListItems(&newLine, appendNewLinesTo: &temp, scanner: scanner, listDelimeterCharacters: characterSet)
                            case .iteratedSimple(let characterSet):
                                scanForListItems(&newLine, appendNewLinesTo: &temp, scanner: scanner, listDelimeterCharacters: characterSet)
                            }
                            if let savedList = scannedItems[listHeadline] {
                                if savedList.count < temp.count {
                                    scannedItems.updateValue(temp, forKey: listHeadline)
                                }
                            } else {
                                scannedItems.updateValue(temp, forKey: listHeadline)
                            }
                        } catch ParserEngineError.couldNotDetermineSymbol {
                            print("Could not determine error")
                        }
                    }
                }
            }
        }
        return scannedItems
    }
    
    /**
     Scans for List Items in a String and Appends to Target Array.

     This function scans a given input string using a provided Scanner instance to identify and extract list items. The list items are identified based on the specified list delimiter characters. Each identified list item is appended to the target array.

     - Parameters:
        - currentLine: A reference to the current line being processed in the input string. This parameter is updated during scanning.
        - target: A reference to an array where the identified list items are appended.
        - scanner: A Scanner instance used for parsing the input string.
        - listDelimeterCharacters: A CharacterSet containing the delimiter characters that indicate the start of a list item.
     */
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

fileprivate extension Scanner {
    func returnNotScannedString() -> String {
        let startingIndex = self.string.startIndex
        let endIndex = self.currentIndex
        var notScannedString = self.string
        notScannedString.removeSubrange(startingIndex..<endIndex)
        return notScannedString
    }
}
