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
        
        if let maximumScannedLines {
            let scoreForNumberedList = scoreForIteratedNumberedList(input: input, maximumScannedLines: maximumScannedLines)
            let scoreForLetteredList = scoreForIteratedLetteredList(input: input, maximumScannedLines: maximumScannedLines)
            let (symbol, scoreForSymbolList) = scoreForSimpleList(input: input, maximumScannedLines: maximumScannedLines) ?? (Character(""), 0)
            let result: [ListDelimiterType: Double] = [
                .simple(CharacterSet(charactersIn: "\(symbol)")): scoreForSymbolList,
                .iteratedSimple(letterCharacterSet): scoreForLetteredList,
                .iteratedSimple(numberCharacterSet): scoreForNumberedList]
            if let maximumScoreElement = result.max (by:{
                $0.value < $1.value
            }) {
                return maximumScoreElement.key
            } else {
                throw ParserEngineError.couldNotDetermineSymbol
            }
        } else {
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
        }
        throw ParserEngineError.couldNotDetermineSymbol
    }
    
    
    ///Return most probable character with number of appearances divided by number of list points
    private func scoreForSimpleList(input: String, maximumScannedLines: Int? = nil) -> (Character, Double)? {
        let basicScanner = Scanner(string: input)
        basicScanner.charactersToBeSkipped = nil
        var basicResult = [Character : Int]()
        var lastChar: Character = "\n"
        var scanningCondition: () -> Bool = { return true }
        if let maximumScannedLines {
            scanningCondition = { basicResult.values.reduce(0, +) < maximumScannedLines }
        }
        while !basicScanner.isAtEnd && scanningCondition() {
            if let currentChar = basicScanner.scanCharacter(){
                if !currentChar.isNewline && lastChar.isNewline {
                    let oldValue = basicResult[currentChar] ?? 0
                    basicResult.updateValue(oldValue + 1, forKey: currentChar)
                }
                lastChar = currentChar
            }
        }
        let numberOfDetections = Double(basicResult.values.reduce(0, +))
        print("Scoring for simple list - number of scanned lines: \(numberOfDetections)")
        if let symbol = basicResult.max(by: { a, b in a.value < b.value }) {
            return (symbol.key, Double(symbol.value) / numberOfDetections)
        } else {
            return nil
        }
    }
    
    private func scoreForIteratedNumberedList(input: String, maximumScannedLines: Int? = nil) -> Double {
        var numberResult = [Int]()
        let numberScanner = Scanner(string: input)
        numberScanner.charactersToBeSkipped = nil
        var lastChar: Character = "\n"
        var numberOfScannedLines: Double = 0
        
        while !numberScanner.isAtEnd && Int(numberOfScannedLines) < maximumScannedLines ?? (Int(numberOfScannedLines) + 1) {
            if let currentChar = numberScanner.scanCharacter(){
                var nextLastValue = currentChar
                if !currentChar.isNewline && lastChar.isNewline {
                    numberOfScannedLines += 1
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
        let score = Double(hits) / numberOfScannedLines
        print("Scoring for numbered list - number of scanned lines: \(numberOfScannedLines)")
        return score
    }
    
    private func scoreForIteratedLetteredList(input: String, maximumScannedLines: Int? = nil) -> Double {
        var result = [String]()
        let scanner = Scanner(string: input)
        scanner.charactersToBeSkipped = nil
        var lastScannedCharacter: Character = "\n"
        var numberOfScannedLines: Double = 0
        
        while !scanner.isAtEnd && Int(numberOfScannedLines) < maximumScannedLines ?? (Int(numberOfScannedLines) + 1){
            if let currentChar = scanner.scanCharacter(){
                var nextLastValue = currentChar
                if !currentChar.isNewline && lastScannedCharacter.isNewline {
                    numberOfScannedLines += 1
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
        let score = Double(hits) / numberOfScannedLines
        print("Scoring for lettered list - number of scanned lines: \(numberOfScannedLines)")
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

