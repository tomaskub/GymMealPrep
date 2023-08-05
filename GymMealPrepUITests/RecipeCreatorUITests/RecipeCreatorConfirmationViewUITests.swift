//
//  RecipeCreatorConfirmationViewUITests.swift
//  GymMealPrepUITests
//
//  Created by Tomasz Kubiak on 7/27/23.
//

import XCTest

final class RecipeCreatorConfirmationViewUITests: XCTestCase {
    //MARK: INFORMATION ABOUT NAMING
    /*
     Naming structure: test_UnitOfWork_StateUnderTest_ExpectedBehaviour
     Naming structure: test_[Struct or class]_[UI component]_[expected result]
     Testing structure: Given, When, Then
     */
    var app: XCUIApplication!
    var helper: RecipeCreatorUITestsHelper!
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
    
    func test_RecipeCreatorConfirmationView_UIElements_exist() {
        // Given
        helper.navigateToRecipeCreatorConfirmationView()
        
        let navigationTitle = app.navigationBars.staticTexts["Add details"]
        let photoSectionHeader = app.collectionViews.staticTexts["PHOTO"]
        let timeCookingSectionHeader = app.collectionViews.staticTexts["TIME COOKING"]
        let tagsSectionHeader = app.collectionViews.staticTexts["TAGS"]
        
        let cookingTimeStaticText = app.collectionViews.staticTexts["Cooking time:"]
        let preparingTimeStaticText = app.collectionViews.staticTexts["Preparing time:"]
        let waitingTimeStaticText = app.collectionViews.staticTexts["Time waiting:"]
        
        let cookingTimeTextField = app.collectionViews.textFields["cooking-time-text-field"]
        let preparingTimeTextField = app.collectionViews.textFields["preparing-time-text-field"]
        let waitingTimeTextField = app.collectionViews.textFields["waiting-time-text-field"]
        
        let addPhotoButton = app.collectionViews.buttons["add-change-photo"]
        let addTagButton = app.collectionViews.buttons["Add"]
        let tagTextField = app.collectionViews.cells.containing(.button, identifier: "Add").textFields["Add new tag"]
        
        // Then
        let predicate = NSPredicate(format: "exists == true")
        var expectations = [XCTestExpectation]()
        for element in [navigationTitle, photoSectionHeader, timeCookingSectionHeader, tagsSectionHeader, cookingTimeStaticText, preparingTimeStaticText, waitingTimeStaticText, cookingTimeTextField, preparingTimeTextField, waitingTimeTextField, addPhotoButton, addTagButton, tagTextField] {
            expectations.append(expectation(for: predicate, evaluatedWith: element))
        }
        let result = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "All elements should exist")
    }
    
    func test_RecipeCreatorConfirmationView_AddButton_addsTagFromTextOnTap() {
        // Given
        helper.navigateToRecipeCreatorConfirmationView()
        let testInput = "Test tag"
        
        // When
        helper.addTag(tagText: testInput)
        
        // Then
        let result = app.collectionViews.staticTexts[testInput].waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "Static text 'Test tag' should exist")
    }
    
    func test_RecipeCreatorConfirmationView_AddButton_doesNotAddTag_whenTextFieldIsEmpty() {
        // Given
        helper.navigateToRecipeCreatorConfirmationView()
        
        // When
        helper.addTag(tagText: "")
        
        // Then
        let addButton = app.collectionViews.buttons["Add"]
        let result = XCTWaiter.wait(for: [expectation(for: NSPredicate(format: "isEnabled == false"), evaluatedWith: addButton)], timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "Add button should not be enabled")
    }
    
    func test_RecipeCreatorConfirmationView_Tag_XButtonExistsAfterLongPress(){
        // Given
        let testInput = "Test tag"
        helper.navigateToRecipeCreatorConfirmationView()
        helper.addTag(tagText: testInput)
        
        // When
        app.collectionViews.staticTexts[testInput].press(forDuration: 1)
        
        // Then
        let result = app.collectionViews.buttons["x.circle"].waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "Delete tag button should exist")
    }
    
    func test_RecipeCreatorConfirmationView_Tag_isRemovedAfterXButtonTap(){
        // Given
        let testInput = "Test tag"
        helper.navigateToRecipeCreatorConfirmationView()
        helper.addTag(tagText: testInput)
        let tag = app.collectionViews.staticTexts[testInput]
        tag.press(forDuration: 1)
        
        // When
        app.collectionViews.buttons["x.circle"].tap()
        
        // Then
        let result = tag.waitForNonExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "'Test tag' static test should not exist")
    }
    
    func test_RecipeCreatorConfirmationView_AddPhotoButton_displaysPhotoPicker() {
        // Given
        helper.navigateToRecipeCreatorConfirmationView()
        
        // When
        helper.tapAddPhotoButton()
        
        // Then
        let result = app.navigationBars["Photos"].waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "A 'Photos' navigation bar should exists after tap")
    }
    
    func test_RecipeCreatorConfirmationView_RecipeImageUpdatedAfterPhotoIsPicked() {
        // Given
        helper.navigateToRecipeCreatorConfirmationView()
        helper.tapAddPhotoButton()
        
        // When
        app.scrollViews.images["Photo, August 08, 2012, 11:29 PM"].tap()
        
        // Then
        let result = app.collectionViews.descendants(matching: .image).firstMatch.waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "Added photo should exist")
    }
    
    func test_RecipeCreatorConfirmationView_AddPhotoButton_changesLabel_whenPhotoIsLoaded() {
        // Given
        helper.navigateToRecipeCreatorConfirmationView()
        helper.tapAddPhotoButton()
        
        // When
        app.scrollViews.images["Photo, August 08, 2012, 11:29 PM"].tap()
        
        // Then
        XCTAssertEqual(app.collectionViews.buttons["add-change-photo"].label, "Change photo", "'add-change-photo' button should have value 'Change photo")
    }
    
    func test_RecipeCreatorConfirmationView_DeleteButton_exists_whenPhotoIsLoaded() {
        // Given
        helper.navigateToRecipeCreatorConfirmationView()
        helper.tapAddPhotoButton()
        
        // When
        app.scrollViews.images["Photo, August 08, 2012, 11:29 PM"].tap()
        
        // Then
        let result = app.collectionViews.buttons["delete-photo"].waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "Delete photo button should exist")
    }
    
    // TOMASZ: FOR THIS TEST TO OPERATE ASSET ID HAS TO BE OBTAINED FROM PHOTO PICKER
    /*
    func test_RecipeCreatorConfirmationView_ChangePhotoButton_changesPhotoOnTap() {
        // Given
        let firstPhotoId = "Photo, August 08, 2012, 11:29 PM"
        let secondPhotoId = "Photo, Augus 08, 2012, 11:55 PM"
        let addPhotoButton = app.collectionViews.buttons["add-change-photo"]
        navigateToRecipeCreatorConfirmationView()
        addPhotoButton.tap()
        firstPhotoId.tap()
        
        // When
        addPhotoButton.tap()
        secondPhotoId.tap()
        // Then
        let result = app.collectionViews.images[secondPhotoId].waitForExistence(timeout: standardTimeout)
        XCTAssertTrue(result, "Image with second photo id should be present")
    }
    */
    func test_RecipeCreatorConfirmationView_DeleteButton_removesPhotoAndItself_whenTaped() {
        // Given
        helper.navigateToRecipeCreatorConfirmationView()
        helper.tapAddPhotoButton()
        app.scrollViews.images["Photo, August 08, 2012, 11:29 PM"].tap()
        
        // When
        helper.tapDeletePhotoButton()
        
        // Then
        let predicate = NSPredicate(format: "exists == false")
        let expectations = [
            expectation(for: predicate, evaluatedWith: app.collectionViews.buttons["delete-photo"]),
            expectation(for: predicate, evaluatedWith: app.collectionViews.descendants(matching: .image).firstMatch)]
        
        let result = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "Photo and delete button should not exist")
    }

    func test_RecipeCreatorConfirmationView_TimeTextFields_areEditable() {
        // Given
        helper.navigateToRecipeCreatorConfirmationView()
        
        // When
        helper.enterCookingTimes(cookingTime: "15", preparingTime: "25", waitingTime: "35")
        
        // Then
        let expectations = [
        expectation(for: NSPredicate(format: "value == '15'"),
                    evaluatedWith: app.collectionViews.textFields["cooking-time-text-field"]),
        expectation(for: NSPredicate(format: "value == '25'"),
                    evaluatedWith: app.collectionViews.textFields["preparing-time-text-field"]),
        expectation(for: NSPredicate(format: "value == '35'"),
                    evaluatedWith: app.collectionViews.textFields["waiting-time-text-field"])
        ]
        
        let result = XCTWaiter.wait(for: expectations, timeout: standardTimeout)
        XCTAssertEqual(result, .completed, "The field values should match the typed in values")
    }
    
}
