//
//  XCUIElement+Extensions.swift
//  GymMealPrepUITests
//
//  Created by Tomasz Kubiak on 7/16/23.
//

import Foundation
import XCTest

extension XCUIElement {
    
    func waitForNonExistence(timeout: TimeInterval) -> Bool {
        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        _ = XCTWaiter.wait(for: [expectation], timeout: timeout)
        return !exists
    }
    
    func clearAndTypeText(_ text: String) {
        guard let stringValue = self.value as? String else { return }
        
        var deleteString = String()
        for _ in stringValue {
            deleteString += XCUIKeyboardKey.delete.rawValue
        }
        
        self.typeText(deleteString)
        self.typeText(text)
    }
}
