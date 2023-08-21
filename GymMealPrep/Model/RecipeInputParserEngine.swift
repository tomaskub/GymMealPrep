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
    
    /// Return list delimeter type for tinput text, if one can be detected
    func findListSymbol() throws -> ListDelimiterType {
        // setup
        guard !input.isEmpty else { throw RecipeInputParserEngineError.emptyInput }
        let basicScanner = Scanner(string: input)
        basicScanner.charactersToBeSkipped = nil
        // start scanning for basic list (exclude numbers and letters)
        var basicResult = [Character : Int]()
        var lastChar: Character = "\n"
        while !basicScanner.isAtEnd {
            if let currentChar = basicScanner.scanCharacter(){
                if !currentChar.isNewline && lastChar.isNewline {
                    let oldValue = basicResult[currentChar] ?? 0
                    basicResult.updateValue(oldValue + 1, forKey: currentChar)
                }
                lastChar = currentChar
            }
        }
        // Evaluate the results of basic delimiter recognition
        let numberOfDetections = Double(basicResult.values.reduce(0, +))
        if let symbol = basicResult.max(by: { a, b in a.value < b.value }) {
            let score = Double(symbol.value) / numberOfDetections
            // see if it is 80% right and assume the rest is a mistake
            if score > 0.8 {
                let returnSet =  CharacterSet(charactersIn: String(symbol.key))
                return ListDelimiterType.simple(returnSet)
            }
            // if the score is really low we can assume that it is numbered/lettered list
            //MARK: if the score is somewhere in between there is a possibility of no delimiter used (chars are repeating and not unique)
        }
        // if failed start scannning for numbered list - this works
        let numberCharacterSet = CharacterSet(charactersIn: "0123456789")
        var numberResult = [Int]()
        let numberScanner = Scanner(string: input)
        numberScanner.charactersToBeSkipped = nil
        lastChar = "\n"
        while !numberScanner.isAtEnd {
            if let currentChar = numberScanner.scanCharacter(){
                var nextLastValue = currentChar
                if !currentChar.isNewline && lastChar.isNewline {
                    if currentChar.isNumber {
                        if let lineNumber = numberScanner.scanUpToCharacters(from: numberCharacterSet.inverted ),
                           let number = Int("\(currentChar)"+lineNumber) {
                            numberResult.append(number)
                            if let lineNumberLastChar = lineNumber.last {
                                nextLastValue = lineNumberLastChar
                            }
                        } else if let number = Int(String(currentChar)) {
                            numberResult.append(number)
                        }
                    }
                }
                lastChar = nextLastValue
            }
        }
        // Evaluate numbers result
//        let weight = Double(numberResult.count) / numberOfDetections
        var hits: Int = 0
        var lastValue: Int = 0
        for value in numberResult {
            if value == lastValue + 1 {
                hits += 1
            }
            lastValue = value
        }
        // see if it is 80% right and assume the rest is a mistake
        if Double(hits) / numberOfDetections > 0.8 {
            return .iteratedSimple(numberCharacterSet)
        }
        // if failed start scanning for lettered list
        let letterCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz")
        var letterResult = [String]() // this maybe should be a string array
        let letterScanner = Scanner(string: input)
        letterScanner.charactersToBeSkipped = nil
        lastChar = "\n"
        while !letterScanner.isAtEnd {
            if let currentChar = letterScanner.scanCharacter(){
                var nextLastValue = currentChar
                if !currentChar.isNewline && lastChar.isNewline {
                    if currentChar.isLetter {
                        if let lineLettering = letterScanner.scanUpToCharacters(from: letterCharacterSet.inverted ) {
                            let lineDelimiter = "\(currentChar)"+lineLettering
                            letterResult.append(lineDelimiter)
                            if let lineDelimeterLastChar = lineLettering.last {
                                    nextLastValue = lineDelimeterLastChar
                            }
                        } else {
                            letterResult.append(String(currentChar))
                        }
                    }
                }
                lastChar = nextLastValue
            }
        }
        // see if it is 80% right and assume the rest is a mistake
        hits = 0
        var lastLetter: String = letterResult.first ?? "a"
        for value in letterResult {
            if value > lastLetter {
                hits += 1
            }
            lastLetter = value
        }
        if Double(hits) / numberOfDetections > 0.8 {
            return .iteratedSimple(letterCharacterSet)
        }
        // assume the list is not using limiter
        throw RecipeInputParserEngineError.couldNotDetermineSymbol
    }
}
