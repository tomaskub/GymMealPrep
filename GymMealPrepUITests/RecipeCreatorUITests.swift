//
//  RecipeCreatorUITests.swift
//  GymMealPrepUITests
//
//  Created by Tomasz Kubiak on 7/12/23.
//

import XCTest

final class RecipeCreatorUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRecipeCreatorTitleRecipe() throws {
        let recipeTitleInput = "Breakfast burrito"
        let ingredientsInput = "2 eggs\n2bacon strips\n1flour tortilla\n28 grams of cheddar cheese\n50 grams of green bell pepper"
        let instructionsInput = "1. Fry bacon strips and scramble the eggs \n2. Remove bacon and eggs, put shredded cheese on the pan. \n3. After the cheese melts, cover cheese with tortilla \n4. Flip the tortilla and put it on plate, top with the rest of ingredients. Roll the burrito.\n5. Put the buttrito on the hot pan, seam side down. After 30 seconds remove and prepare for serving"
        // lunch app
        let app = XCUIApplication()
        //navigate to recipe creator host view
        app.launch()
        app.tabBars["Tab Bar"].buttons["Recipes"].tap()
        let recipiesNavigationBar = app.navigationBars["Recipies"]
        recipiesNavigationBar/*@START_MENU_TOKEN@*/.images["Back"]/*[[".otherElements[\"Back\"].images[\"Back\"]",".images[\"Back\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertTrue(recipiesNavigationBar.buttons["Add from text"].exists, "Button add from text should exist")
        recipiesNavigationBar/*@START_MENU_TOKEN@*/.buttons["Add from text"]/*[[".otherElements[\"Add from text\"].buttons[\"Add from text\"]",".buttons[\"Add from text\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        // type in input data
        let recipeTitleElementsQuery = app.scrollViews.otherElements.containing(.textField, identifier:"Recipe title")
        let titleTextField = recipeTitleElementsQuery.textFields["Recipe title"]
        XCTAssertTrue(titleTextField.exists, "Recipe title text field should exist")
        titleTextField.tap()
        titleTextField.typeText(recipeTitleInput)

        let nextButton = app.toolbars["Toolbar"]/*@START_MENU_TOKEN@*/.buttons["Next"]/*[[".otherElements[\"Next\"].buttons[\"Next\"]",".buttons[\"Next\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(nextButton.exists, "Next button on keyboard toolbar should exist")
        nextButton.tap()
        
        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
