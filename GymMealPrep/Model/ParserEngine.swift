//
//  ParserEngine.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 21/08/2023.
//

import Foundation

class ParserEngine {
    let numberCharacterSet = CharacterSet(charactersIn: "0123456789")
    let letterCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz")
    
    typealias ListDelimierScore = (ListDelimiterType, Double)
    
    func findListSymbol(in input: String, maximumScannedLines: Int? = nil) throws -> ListDelimiterType {
        
        guard !input.isEmpty else { throw ParserEngineError.emptyInput }
        
        if let symbol = scoreForSimpleList(input: input) {
            let score = Double(symbol.1)
            if score > 0.8 {
                let returnSet =  CharacterSet(charactersIn: String(symbol.0))
                return ListDelimiterType.simple(returnSet)
            }
        }
        
        if scoreForIteratedNumberedList(input: input) > 0.8 {
            return .iteratedSimple(numberCharacterSet)
        }
        
        if scoreForIteratedLetteredList(input: input) > 0.8 {
            return .iteratedSimple(letterCharacterSet)
        }
            
        throw ParserEngineError.couldNotDetermineSymbol
    }
    
    
    ///Return most probable character with number of appearances divided by number of list points
    private func scoreForSimpleList(input: String) -> (Character, Double)? {
        // if the score is really low we can assume that it is numbered/lettered list
        //MARK: if the score is somewhere in between there is a possibility of no delimiter used (chars are repeating and not unique)
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
            return (symbol.key, Double(symbol.value) / numberOfDetections)
        } else {
            return nil
        }
    }
    
    private func scoreForIteratedNumberedList(input: String) -> Double {
        var numberResult = [Int]()
        let numberScanner = Scanner(string: input)
        numberScanner.charactersToBeSkipped = nil
        var lastChar: Character = "\n"
        var numberOfDetections: Double = 0
        while !numberScanner.isAtEnd {
            if let currentChar = numberScanner.scanCharacter(){
                var nextLastValue = currentChar
                if !currentChar.isNewline && lastChar.isNewline {
                    numberOfDetections += 1
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
        var hits: Int = 0
        var lastValue: Int = 0
        for value in numberResult {
            if value == lastValue + 1 {
                hits += 1
            }
            lastValue = value
        }
        let score = Double(hits) / numberOfDetections
        return score
    }
    
    private func scoreForIteratedLetteredList(input: String) -> Double {
        var result = [String]()
        let scanner = Scanner(string: input)
        scanner.charactersToBeSkipped = nil
        var lastScannedCharacter: Character = "\n"
        var numberOfLines: Double = 0
        
        while !scanner.isAtEnd {
            if let currentChar = scanner.scanCharacter(){
                var nextLastValue = currentChar
                if !currentChar.isNewline && lastScannedCharacter.isNewline {
                    numberOfLines += 1
                    if currentChar.isLetter {
                        if let lineLettering = scanner.scanUpToCharacters(from: letterCharacterSet.inverted ) {
                            let lineDelimiter = "\(currentChar)"+lineLettering
                            result.append(lineDelimiter)
                            if let lineDelimeterLastChar = lineLettering.last {
                                nextLastValue = lineDelimeterLastChar
                            }
                        } else {
                            result.append(String(currentChar))
                        }
                    }
                }
                lastScannedCharacter = nextLastValue
            }
        }
        // see if it is 80% right and assume the rest is a mistake
        var hits: Int = 0
        var lastLetter: String = result.first ?? "a"
        for value in result {
            if value > lastLetter {
                hits += 1
            }
            lastLetter = value
        }
        let score = Double(hits) / numberOfLines
        
        return score
    }
    
    func scanNewLine(scanner: Scanner) -> String? {
        var currentChar: Character = Character("\n")
        while currentChar.isNewline && !scanner.isAtEnd {
            currentChar = scanner.scanCharacter() ?? Character("\n")
        }
        var newLine: String = String(currentChar)
        newLine.append(scanner.scanUpToCharacters(from: .newlines) ?? String())
        return newLine
    }
}

