//
//  Datamanager+MealPlanMOTests.swift
//  GymMealPrepTests
//
//  Created by Tomasz Kubiak on 6/28/23.
//

import XCTest

final class DataManager_MealPlanMOTests: XCTestCase {
    var sut: DataManager!
    
    override func setUp() {
        sut = DataManager.testing
    }

    override func tearDown() {
        sut = nil
    }
    
    
}
