//
//  RecipeInputParserEngineTests.swift
//  Pods
//
//  Created by Tomasz Kubiak on 16/08/2023.
//
@testable import GymMealPrep
import XCTest

final class RecipeInputParserEngineTests: XCTestCase {
    
    var sut: RecipeInputParserEngine!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_findListSymbol_whenSameSymbolOnNewLine() throws {
        sut = RecipeInputParserEngine(input: InputStaticStrings.ingredientsWithBulletList)
        let result = try sut.findListSymbol()
        XCTAssertEqual(result, CharacterSet(charactersIn: "•"))
    }
    
    func test_parseIngredients() throws {
        sut = RecipeInputParserEngine(input: InputStaticStrings.ingredientsWithBulletList)
        let result = try sut.parseIngredients()
        let expectation = ["1 - Whole Bulb Garlic", "2 ½ Tbsp (50g) - Natural Greek Yogurt","1 - Garlic Clove, Minced","¼ - Lemon, Zested", "¼ - Lime, Zest","¼ - Lemon, Juiced", "3 Tbsp (42g) - Butter", "1 ½ tsp (4g) - Smoked Paprika", "½ (2g) - Dried Chilli Flakes", "3 tsp (15ml) - White Vinegar", "2-4 - Free Range Eggs", "1 ½ tsp (7.5ml) - Extra Virgin Olive Oil (Optional)", "Brioche Bread Or Bread Of Choice, Lightly Toasted", "Seasoning To Taste", "Dill To Garnish", "Parsley To Garnish"]
        XCTAssertEqual(result.first, expectation.first)
    }
    
    
//    func testPerformanceExample() {
//        sut = RecipeInputParserEngine(input: InputStaticStrings.ingredientsWithBulletList)
//        self.measure {
//            let result = try sut.parseIngredients()
//        }
//    }

}

extension RecipeInputParserEngineTests {
   
    
  
    struct InputStaticStrings {
        static let ingredientsWithBulletList = """
        •1 - Whole Bulb Garlic
        •2 ½ Tbsp (50g) - Natural Greek Yogurt
        •1 - Garlic Clove, Minced
        •¼ - Lemon, Zested
        •¼ - Lime, Zest
        •¼ - Lemon, Juiced
        •3 Tbsp (42g) - Butter
        •1 ½ tsp (4g) - Smoked Paprika
        •½ (2g) - Dried Chilli Flakes
        •3 tsp (15ml) - White Vinegar
        •2-4 - Free Range Eggs
        •1 ½ tsp (7.5ml) - Extra Virgin Olive Oil (Optional)
        •Brioche Bread Or Bread Of Choice, Lightly Toasted
        •Seasoning To Taste
        •Dill To Garnish
        •Parsley To Garnish
        """
        static let instructionsWithBulletList =
            """
        •Preheat oven to 180.c - 350.f. Place the whole garlic bulb onto a sheet of aluminium foil, drizzle over the oil, fold into a parcel, and roast in the oven for 45 minutes or until soft and tender. Remove and let cool slightly.
        •Place a small pan over medium heat; add the butter, smoked paprika, chilli flakes and seasoning to taste. Melt and cook for 2 minutes. Remove and set aside.
        •In the meantime, prepare the citrus yogurt sauce by placing the yogurt into a bowl, adding the minced garlic, lemon and lime zest, lemon juice and seasoning to taste.
        •Bring a saucepan of water over high heat, add the vinegar and bring to a boil. Poach the eggs for 2 1/2 minutes or until done to your liking. Remove and drain on a paper towel.
        •Toast the bread to your liking, and spread with the roasted garlic and citrus yogurt dressing. Add the poached eggs and drizzle with the smoked paprika and chilli butter. Garnish with dill, parsley and cracked black pepper.
        """
    }
}
