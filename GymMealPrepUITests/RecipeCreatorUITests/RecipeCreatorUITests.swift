//
//  RecipeCreatorUserWorkflowUITests.swift
//  GymMealPrepUITests
//
//  Created by Tomasz Kubiak on 8/2/23.
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
    var helper: RecipeCreatorUITestsHelper!
    //MARK: static input properties
    
    let standardTimeout = 2.5
    
    override func setUp() {
        app = XCUIApplication()
        helper = RecipeCreatorUITestsHelper(forApplication: app)
        continueAfterFailure = false
        app.launchArguments = ["-UITests"]
        app.launch()
    }

    override func tearDown() {
        app = nil
        helper = nil
    }
    
    func test_RecipeCreator_UserAddingRecipeFromText() {
        // Given
        let tags = ["breakfast", "mexican", "burrito", "freezer-friendly"]
        helper.navigateToRecipeCreatorViewFromText()
        helper.tapToolTips()
        helper.enterData()
        helper.advanceStage(numberOfStages: 3)
        helper.addPhoto(photoId: "Photo, August 08, 2012, 11:29 PM")
        helper.enterCookingTimes(cookingTime: "15",
                                 preparingTime: "10",
                                 waitingTime: "0")
        helper.addTags(tagTexts: tags)
        
        // When
        helper.tapSaveAndOpenButton()
        
        // Then
        let expectations: [XCTestExpectation] = {
            let predicate = NSPredicate(format: "exists == true")
            var array = [
                expectation(for: predicate, evaluatedWith: app.collectionViews.images.firstMatch),
                expectation(for: predicate, evaluatedWith: app.collectionViews.cells.staticTexts[RecipeCreatorUITestsHelper.RecipeInputStrings.recipeTitleInput])
            ]
            for tag in tags {
                array.append(
                    expectation(for: predicate, evaluatedWith: app.collectionViews.staticTexts[tag])
                )
            }
            return array
        }()
        
        let result = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "Basic elements should exist")
    }
}
