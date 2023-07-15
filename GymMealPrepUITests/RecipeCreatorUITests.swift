//
//  RecipeCreatorUITests.swift
//  GymMealPrepUITests
//
//  Created by Tomasz Kubiak on 7/12/23.
//

import XCTest

final class RecipeCreatorUITests: XCTestCase {
    
    //MARK: INFORMATION ABOUT NAMING
    /*
     Naming structure: test_UnitOfWork_StateUnderTest_ExpectedBehaviour
     Naming structure: test_[Struct or class]_[UI component]_[expected result]
     Testing structure: Given, When, Then
     */

    var app: XCUIApplication!
    
    //MARK: static input properties
    let recipeTitleInput = "Breakfast burrito"
    let ingredientsInput = "2 eggs\n2bacon strips\n1flour tortilla\n28 grams of cheddar cheese\n50 grams of green bell pepper"
    let instructionsInput = "1. Fry bacon strips and scramble the eggs \n2. Remove bacon and eggs, put shredded cheese on the pan. \n3. After the cheese melts, cover cheese with tortilla \n4. Flip the tortilla and put it on plate, top with the rest of ingredients. Roll the burrito.\n5. Put the buttrito on the hot pan, seam side down. After 30 seconds remove and prepare for serving"
    
    override func setUp() {
        app = XCUIApplication()
        continueAfterFailure = false
        app.launch()
    }

    override func tearDown() {
        app = nil
    }
    
    func test_RecipeCreatorHostView_expandableButton_shouldExpandOnTap() throws {
        // Given
        navigateToRecipeList()
        
        // When
        let recipiesNavigationBar = app.navigationBars["Recipies"]
        recipiesNavigationBar/*@START_MENU_TOKEN@*/.images["Back"]/*[[".otherElements[\"Back\"].images[\"Back\"]",".images[\"Back\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        // Then
        let addFromTextButton = recipiesNavigationBar.buttons["Add from text"]
        let addFromTextButtonExists = addFromTextButton.waitForExistence(timeout: 2.5)
        XCTAssertTrue(addFromTextButtonExists, "Button add from text should exist")
    }
    
    
    func test_RecipeCreatorHostView_Navigation_shouldNavigateToView() throws {
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
    
    // do not test performance in this suite of testing
    /*
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
     */
}
//MARK: HELPER FUNCTIONS
extension RecipeCreatorUITests {
    
    func navigateToRecipeList() {
        app.tabBars["Tab Bar"].buttons["Recipes"].tap()
        
    }
}
