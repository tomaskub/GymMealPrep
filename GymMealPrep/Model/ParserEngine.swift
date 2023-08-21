//
//  ParserEngine.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 21/08/2023.
//

import Foundation

class ParserEngine {
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

