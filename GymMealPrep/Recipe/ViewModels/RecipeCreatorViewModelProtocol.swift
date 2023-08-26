//
//  RecipeCreatorViewModelProtocol.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 8/11/23.
//

import Foundation
import SwiftUI
import PhotosUI

/// This class is a protocol definition for view model of RecipeCreatorViews
class RecipeCreatorViewModelProtocol: ObservableObject, IngredientSaveHandler {
    
    // input properties
    @Published var recipeLink: String = String()
    @Published var recipeTitle: String = String()
    @Published var ingredientsEntry: String = String()
    @Published var instructionsEntry: String = String()
    @Published var timePreparingInMinutes: String = String()
    @Published var timeCookingInMinutes: String = String()
    @Published var timeWaitingInMinutes: String = String()
    @Published var tagText: String = String()
    @Published var servings: Int = 1
    // input processed properties
    @Published var ingredientsNLArray: [String] = []
    var instructionsNLArray: [String] = []
    // output properties
    @Published var parsedIngredients = [String : [[Ingredient]]]()
    @Published var matchedIngredients = [String : Ingredient]()
    @Published var parsedInstructions: [Instruction] = []
    @Published var tags: [Tag] = []
    // processing properties
    @Published var isProcessingData: Bool = false
    @Published var processName = String()
    // alert properties
    @Published var isShowingAlert: Bool = false
    var alertTitle: String = String()
    var alertMessage: String = String()
    
    func processInput() {
        assertionFailure("Missing override: Please override this method in the subclass")
    }
    func processLink() {
        assertionFailure("Missing override: Please override this method in the subclass")
    }
    func addIngredient(_: Ingredient, _: String?) {
        assertionFailure("Missing override: Please override this method in the subclass")
    }
    func saveRecipe() -> Recipe {
        assertionFailure("Missing override: Please override this method in the subclass")
        return Recipe()
    }
    func addTag() {
        assertionFailure("Missing override: Please override this method in the subclass")
    }
    
    func deleteInstruction(at offset: IndexSet) {
        assertionFailure("Missing override: Please override this method in the subclass")
    }
    func moveInstruction(fromOffset source: IndexSet, toOffset destination: Int) {
        assertionFailure("Missing override: Please override this method in the subclass")
    }
    func addInstruction() {
        assertionFailure("Missing override: Please override this method in the subclass")
    }
    func addImageData(data: Data) {
        assertionFailure("Missing override: Please override this method in the subclass")
    }
    func deleteImageData() {
        assertionFailure("Missing override: Please override this method in the subclass")
    }
    func clearAlertMessage() {
        alertTitle = String()
        alertMessage = String()
    }
}
