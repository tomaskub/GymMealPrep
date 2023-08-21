//
//  RecipeInputParserEngineTests.swift
//  Pods
//
//  Created by Tomasz Kubiak on 16/08/2023.
//
@testable import GymMealPrep
import XCTest

final class RecipeInputParserEngineTests: XCTestCase {
    
    //MARK: LIST DELIMITER STYLES TESTED BELOW
    // basic lists - no delimeter
    // basic lists - list with a singular delimiter
    // iterated list - list with a letter or number increasing
    
    var sut: RecipeInputParserEngine!
    
    override func setUpWithError() throws {
        sut = RecipeInputParserEngine(input: "test")
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
}
 
//MARK: PARSING LIST TESTS
extension RecipeInputParserEngineTests {
    func test_parsingList_withSimpleDelimiterPresent() throws {
        let textInput = generateInputWithSimpleDelimiter(from: InputStaticStrings.ingredientsArray, delimiter: "-")
        sut.setInput(input: textInput)
        let result = try sut.parseList()
        XCTAssertEqual(result, InputStaticStrings.ingredientsArray, "The parsed array should be equal to array used to construct the input")
    }
    
    func test_parsingList_withSimpleDelimeterNotPresent() throws {
        let textInput = generateInputWithSimpleDelimiter(from: InputStaticStrings.ingredientsArray, delimiter: nil)
        sut.setInput(input: textInput)
        let result = try sut.parseList()
        XCTAssertEqual(result, InputStaticStrings.ingredientsArray, "The parsed array should be equal to array used to construct the input")
    }
    
    func test_parsingList_withIteratedNumberDelimiter() throws {
        let textInput = generateInputWithIteratedDelimiter(from: InputStaticStrings.ingredientsArray, iteratorType: .numerical)
        sut.setInput(input: textInput)
        let result = try sut.parseList()
        XCTAssertEqual(result, InputStaticStrings.ingredientsArray, "The parsed array should be equal to array used to construct the input")
    }
    
    func test_parsingList_withIteratedLetterDelimiter() throws {
        let textInput = generateInputWithIteratedDelimiter(from: InputStaticStrings.ingredientsArray, iteratorType: .alphabetical)
        sut.setInput(input: textInput)
        let result = try sut.parseList()
        XCTAssertEqual(result, InputStaticStrings.ingredientsArray, "The parsed array should be equal to array used to construct the input")
    }
}
//MARK: CONVINIENCE FUNCTIONS
extension RecipeInputParserEngineTests {
    // Test for input generation - prints into console generated input - do not need to run in test suite
    /*
    func test_inputGenerations() {
        let input = InputStaticStrings.ingredientsArray
        let simple = generateInputWithSimpleDelimiter(from: input, delimiter: "-")
        print("Basic iterator generates:\n\n\(simple)\n\n")
        let first = generateInputWithIteratedDelimiter(from: input, iteratorType: .alphabetical)
        print("Alphabetical iterator generates:\n\n\(first)\n\n")
        let second = generateInputWithIteratedDelimiter(from: input, iteratorType: .numerical)
        print("Numerical iterator generates:\n\n\(second)\n\n")
    }
    */
    fileprivate enum ListIteratorType {
        case numerical
        case alphabetical
    }
    fileprivate func generateInputWithSimpleDelimiter(from source: [String], delimiter: Character?) -> String {
        
        let array = source.map { element in
            if let delimiter {
                return "\(delimiter)"+element+"\n"
            } else {
                return element+"\n"
            }
        }
        return array.reduce(String()) { a, b in
            a.isEmpty ? b : a+b
        }
    }
    
    fileprivate func generateInputWithIteratedDelimiter(from source: [String], iteratorType: ListIteratorType) -> String {
        var result = [String]()
        switch iteratorType {
        case .numerical:
            for (index, element) in source.enumerated() {
                let newElement = "\(index + 1). "+element+"\n"
                result.append(newElement)
            }
        case .alphabetical:
            
            for (index, element) in source.enumerated() {
                let iterator = returnLetterIterator(index: index)
                let newElement = "\(iterator). "+element+"\n"
                result.append(newElement)
            }
        }
        
        return result.reduce(String()) { a, b in
            a.isEmpty ? b : a+b
        }
    }
    private func returnLetterIterator(index: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz"
        if Double(index + 1) / Double(letters.count) <= Double(1) {
            let iteratorIndex = letters.index(letters.startIndex, offsetBy: index)
            let iterator = letters[iteratorIndex]
            return String(iterator)
        } else {
            let firstIteratorIndex = letters.index(letters.startIndex, offsetBy: index/26)
            let firstIterator = letters[firstIteratorIndex]
            let secondIteratorIndex = letters.index(letters.startIndex, offsetBy: index%26)
            let secondIterator = letters[secondIteratorIndex]
            return String(firstIterator)+String(secondIterator)
        }
    }
    struct InputStaticStrings {
        static let ingredientsArray = ["1 - Whole Bulb Garlic", "2 ½ Tbsp (50g) - Natural Greek Yogurt","1 - Garlic Clove, Minced","¼ - Lemon, Zested", "¼ - Lime, Zest","¼ - Lemon, Juiced", "3 Tbsp (42g) - Butter", "1 ½ tsp (4g) - Smoked Paprika", "½ (2g) - Dried Chilli Flakes", "3 tsp (15ml) - White Vinegar", "2-4 - Free Range Eggs", "1 ½ tsp (7.5ml) - Extra Virgin Olive Oil", "Brioche Bread Or Bread Of Choice, Lightly Toasted", "Seasoning To Taste", "Dill To Garnish", "Parsley To Garnish"]
        
        static let instructionsArray =
        [
            "Preheat oven to 180.c - 350.f. Place the whole garlic bulb onto a sheet of aluminium foil, drizzle over the oil, fold into a parcel, and roast in the oven for 45 minutes or until soft and tender. Remove and let cool slightly",
            "Place a small pan over medium heat; add the butter, smoked paprika, chilli flakes and seasoning to taste. Melt and cook for 2 minutes. Remove and set aside.",
            "In the meantime, prepare the citrus yogurt sauce by placing the yogurt into a bowl, adding the minced garlic, lemon and lime zest, lemon juice and seasoning to taste.",
            "Bring a saucepan of water over high heat, add the vinegar and bring to a boil. Poach the eggs for 2 1/2 minutes or until done to your liking. Remove and drain on a paper towel.",
            "Toast the bread to your liking, and spread with the roasted garlic and citrus yogurt dressing. Add the poached eggs and drizzle with the smoked paprika and chilli butter. Garnish with dill, parsley and cracked black pepper."
        ]
    }
}
