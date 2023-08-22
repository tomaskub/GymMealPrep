//
//  WebsiteRecipeParserEngineTests.swift
//  GymMealPrepTests
//
//  Created by Tomasz Kubiak on 15/08/2023.
//

@testable import GymMealPrep
import XCTest

final class WebsiteRecipeParserEngineTests: XCTestCase {
    
    var sut: WebsiteRecipeParserEngine!
    
    override func setUp() {
        sut = WebsiteRecipeParserEngine()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testParsingOutIngredients() throws {
        guard let data = getFile("TestWebsiteData", withExtension: "html") else { fatalError("Failed to retrive data from file") }
        let attributedString = try NSAttributedString(data: data,
                                                    options: [.documentType: NSAttributedString.DocumentType.html,
                                                              .characterEncoding: String.Encoding.utf8.rawValue],
                                                    documentAttributes: nil)
        let result = try sut.scanForListsData(in: attributedString.string, listHeadlines: ["ingredients", "instructions"])
        guard let resultIngredients = result["ingredients"] else { fatalError() }
        XCTAssertEqual(resultIngredients.count, Output.ingredientsResult.count, "Resulting array should have correct count of element")
        for (i, element) in resultIngredients.enumerated() {
            XCTAssertEqual(element.trimmingCharacters(in: .whitespaces), Output.ingredientsResult[i], "Element at index: \(i) is parsed incorrectly")
        }
    }
    
    func testParsingOutInstructions() throws {
        guard let data = getFile("TestWebsiteData", withExtension: "html") else { fatalError("Failed to retrive data from file") }
        let attributedString = try NSAttributedString(data: data,
                                                    options: [.documentType: NSAttributedString.DocumentType.html,
                                                              .characterEncoding: String.Encoding.utf8.rawValue],
                                                    documentAttributes: nil)
        let result = try sut.scanForListsData(in: attributedString.string, listHeadlines: ["ingredients", "instructions"])
        guard let resultInstructions = result["instructions"] else { fatalError() }
        XCTAssertEqual(resultInstructions.count, Output.instructionsResult.count, "Resulting array should have correct count of element")
        for (i, element) in resultInstructions.enumerated() {
            XCTAssertEqual(element.trimmingCharacters(in: .whitespaces), Output.instructionsResult[i], "Element at index: \(i) is parsed incorrectly")
        }
    }
}


//MARK: INPUT DATA AND OUTPUT RESULTS
extension WebsiteRecipeParserEngineTests {
    
    ///Get data from file in current bundle and return as data
    ///- Parameters:
    /// - name: fileName
    /// - withExtension: extension name, i. e. "xml"
    ///- Returns: Data of the onents of the file or nil if file is not found
    func getFile(_ name: String, withExtension: String) -> Data? {
        guard let url = Bundle(for: Self.self)
            .url(forResource: name, withExtension: withExtension) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        return data
    }
    
    struct Output {
        static let ingredientsResult = [
            "•1 - Whole Bulb Garlic",
            "•2 ½ Tbsp (50g) - Natural Greek Yogurt",
            "•1 - Garlic Clove, Minced",
            "•¼ - Lemon, Zested",
            "•¼ - Lime, Zest",
            "•¼ - Lemon, Juiced",
            "•3 Tbsp (42g) - Butter",
            "•1 ½ tsp (4g) - Smoked Paprika",
            "•½ (2g) - Dried Chilli Flakes",
            "•3 tsp (15ml) - White Vinegar",
            "•2-4 - Free Range Eggs",
            "•1 ½ tsp (7.5ml) - Extra Virgin Olive Oil (Optional)",
            "•Brioche Bread Or Bread Of Choice, Lightly Toasted",
            "•Seasoning To Taste",
            "•Dill To Garnish",
            "•Parsley To Garnish"]
        
        static let instructionsResult = [
            "•Preheat oven to 180.c - 350.f. Place the whole garlic bulb onto a sheet of aluminium foil, drizzle over the oil, fold into a parcel, and roast in the oven for 45 minutes or until soft and tender. Remove and let cool slightly.",
            "•Place a small pan over medium heat; add the butter, smoked paprika, chilli flakes and seasoning to taste. Melt and cook for 2 minutes. Remove and set aside.",
            "•In the meantime, prepare the citrus yogurt sauce by placing the yogurt into a bowl, adding the minced garlic, lemon and lime zest, lemon juice and seasoning to taste.",
            "•Bring a saucepan of water over high heat, add the vinegar and bring to a boil. Poach the eggs for 2 1/2 minutes or until done to your liking. Remove and drain on a paper towel.",
            "•Toast the bread to your liking, and spread with the roasted garlic and citrus yogurt dressing. Add the poached eggs and drizzle with the smoked paprika and chilli butter. Garnish with dill, parsley and cracked black pepper."]
    }
}
