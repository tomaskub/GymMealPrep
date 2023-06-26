//
//  DataManagerTests.swift
//  GymMealPrepTests
//
//  Created by Tomasz Kubiak on 5/7/23.
//

import XCTest
@testable import GymMealPrep

final class DataManagerTagMOTests: XCTestCase {

    var sut: DataManager!
    override func setUp() {
        sut = DataManager.testing
    }

    override func tearDown() {
        sut = nil
    }
    
    /// Test function updateAndSave, with condition that a new tag is added
    func testUpdateAndSave_whenNoTagsExist() {
        let tag = Tag(text: "Test tag")
        sut.updateAndSave(tag: tag)
        
        let request = TagMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", tag.id as CVarArg)
        request.fetchLimit = 1
        do {
            let result = try sut.managedContext.fetch(request)
            XCTAssertTrue(result[0].text == tag.text, "Text in TagMO should be equal to text in tag")
        } catch {
            XCTFail("Error while fetching: \(error.localizedDescription)")
        }
    }
    
    func testUpdateAndSave_whenTagExist() {
        let tag = Tag(text: "Test tag")
        sut.updateAndSave(tag: tag)
        
        let newTag = Tag(id: tag.id, text: "Test tag 2")
        sut.updateAndSave(tag: newTag)
        
        let request = TagMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", tag.id as CVarArg)
        request.fetchLimit = 1
        do {
            let result = try sut.managedContext.fetch(request)
            XCTAssertTrue(result[0].text == newTag.text, "Text in TagMO should be equal to text in newTag")
        } catch {
            XCTFail("Error while fetching: \(error.localizedDescription)")
        }
    }
    
    func testDeleteTag_whenNoTagExist() {
        let tag = Tag(text: "Test tag")

        sut.delete(tag: tag)
        
        let request = TagMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", tag.id as CVarArg)
        request.fetchLimit = 1
        do {
            let result = try sut.managedContext.fetch(request)
            XCTAssertTrue(result.isEmpty, "The resulting array should be empty")
        } catch {
            XCTFail("Error while fetching: \(error.localizedDescription)")
        }
    }
    
    func testDeleteTag_whenTagExists() {
        let tag = Tag(text: "Test tag")
        sut.updateAndSave(tag: tag)
        
        sut.delete(tag: tag)
        
        let request = TagMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", tag.id as CVarArg)
        request.fetchLimit = 1
        do {
            let result = try sut.managedContext.fetch(request)
            XCTAssertTrue(result.isEmpty, "The resulting array should be empty")
        } catch {
            XCTFail("Error while fetching: \(error.localizedDescription)")
        }
    }
    
    /*
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
     */
}
