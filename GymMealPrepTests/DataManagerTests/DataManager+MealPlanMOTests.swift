//
//  Datamanager+MealPlanMOTests.swift
//  GymMealPrepTests
//
//  Created by Tomasz Kubiak on 6/28/23.
//

import XCTest
@testable import GymMealPrep

final class DataManager_MealPlanMOTests: XCTestCase {
    
    var sut: DataManager!
    
    override func setUp() {
        sut = DataManager.testing
    }

    override func tearDown() {
        sut = nil
    }
    
    func testUpdateAndSave_whenNoMealPlanExists() {
        let mealPlan = MealPlan(name: "Test meal plan", meals: [])
        
        sut.updateAndSave(mealPlan: mealPlan)
        
        let result = sut.fetchFirst(MealPlanMO.self, predicate: NSPredicate(format: "id = %@", mealPlan.id as CVarArg))
        
        switch result {
        case .success (let success):
            if let mealPlanMO = success {
                
                XCTAssertEqual(mealPlanMO.id, mealPlan.id, "Id of the retrieved mealPlanMO should be equal to id of saved mealPlan")
                
            } else {
                XCTFail("Result of fetch first was not castable as mealPlanMO")
            }
        case .failure (let failure):
            XCTFail("Failed in retrieving saved result: \(failure.localizedDescription)")
        }
    }
}
