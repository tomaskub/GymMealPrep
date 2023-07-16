//
//  XCT+Focus.swift
//  GymMealPrepUITests
//
//  Created by Tomasz Kubiak on 7/16/23.
//

import Foundation
import XCTest

extension XCTestCase {
    func waitUtilElementHasKeyboardFocus(element: XCUIElement, timeout: TimeInterval, file: StaticString = #file, line: UInt = #line) -> XCUIElement {
        let expectation = expectation(description: "waiting for element \(element) to have focus")
        
        let timer = Timer(timeInterval: 1, repeats: true) { timer in
            guard element.value(forKey: "hasKeyboardFocus") as? Bool ?? false else { return }
            
            expectation.fulfill()
            timer.invalidate()
        }
        
        RunLoop.current.add(timer, forMode: .common)
        wait(for: [expectation], timeout: timeout)
        return element
    }
}
