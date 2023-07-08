//
//  RecipieViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//

import Foundation
import SwiftUI
import UIKit
import PhotosUI

class RecipeViewModel: ObservableObject {
    
    //MARK: PUBLISHED PROPERTIES
    @Published var recipe: Recipe
    @Published var tagText = String()
    @Published var selectedIngredient: Ingredient?
    @Published private var recipeDataManager: RecipeDataManagerProtocol
    @Published var selectedPhoto: PhotosPickerItem? = nil {
        didSet {
            if let selectedPhoto {
                Task { @MainActor in 
                    recipe.imageData = try await loadTransferable(from: selectedPhoto)
                }
            }
        }
    }
    
    var totalTimeCookingInMinutes: Int {
        return (recipe.timeCookingInMinutes ?? 0)  + (recipe.timePreparingInMinutes ?? 0) + (recipe.timeWaitingInMinutes ?? 0)
    }
    
    
    @Published var timePreparingInMinutes: String
    @Published var timeCookingInMinutes: String
    @Published var timeWaitingInMinutes: String
    
    func updateTimeData() {
        recipe.timeCookingInMinutes = Int(timeCookingInMinutes) ?? 0
        recipe.timeWaitingInMinutes = Int(timeWaitingInMinutes) ?? 0
        recipe.timePreparingInMinutes = Int(timePreparingInMinutes) ?? 0
    }
    
    var image: Image {
        if let imageData = recipe.imageData, let uiImage = UIImage(data: imageData) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "takeoutbag.and.cup.and.straw")
        }
    }
    
    
    init(recipe: Recipe, dataManager: RecipeDataManagerProtocol = DataManager.shared) {
        self.recipe = recipe
        if let timePreparing = recipe.timePreparingInMinutes {
            self.timePreparingInMinutes = "\(timePreparing)"
        } else {
            self.timePreparingInMinutes = String()
            }
        if let timeCooking = recipe.timeCookingInMinutes {
            self.timeCookingInMinutes = "\(timeCooking)"
        } else {
            self.timeCookingInMinutes = String()
        }
        if let timeWaiting = recipe.timeWaitingInMinutes {
            self.timeWaitingInMinutes = "\(timeWaiting)"
        } else {
            self.timeWaitingInMinutes = String()
        }
        self.recipeDataManager = dataManager
        
    }
    
    func saveRecipe() {
        recipeDataManager.updateAndSave(recipe: recipe)
    }
}

extension RecipeViewModel {
    
    func removeInstruction(at indexSet: IndexSet) {
        recipe.instructions.remove(atOffsets: indexSet)
    }
    func moveInstruction(from start: IndexSet, to finish: Int) {
        recipe.instructions.move(fromOffsets: start, toOffset: finish)
        //update step values to match the position in the array
        for i in 0..<recipe.instructions.count {
            recipe.instructions[i].step = i+1
        }
    }
    func addInstruction() {
        let instruction = Instruction(id: UUID(), step: recipe.instructions.count + 1)
        recipe.instructions.append(instruction)
    }
}

//MARK: TAG EDIT
extension RecipeViewModel {
    
    /// Create tag with a new UUID and tagText to the recipie referenced by view model
    func addTag() {
        let tag = Tag(id: UUID(), text: tagText)
        recipe.tags.append(tag)
        tagText = String()
    }
    
    
}

//MARK: INGREDIENT EDIT
extension RecipeViewModel: IngredientSaveHandler {
    
    func removeIngredient(at indexSet: IndexSet) {
        recipe.ingredients.remove(atOffsets: indexSet)
    }
    
    func moveIngredient(from: IndexSet, to: Int) {
        recipe.ingredients.move(fromOffsets: from, toOffset: to)
    }
    
    func addIngredient(_ ingredientToSave: Ingredient, _: String?) {
        if let i = recipe.ingredients.firstIndex(where: {ingredientToSave.id == $0.id}) {
            recipe.ingredients[i] = ingredientToSave
        } else {
            recipe.ingredients.append(ingredientToSave)
        }
    }
}

extension RecipeViewModel {
    private func loadTransferable(from imageSelection: PhotosPickerItem?) async throws -> Data? {
        do {
            if let data = try await imageSelection?.loadTransferable(type: Data.self) {
                if let _ = UIImage(data: data) {
                    return data
                }
            }
            return nil
        } catch {
            print("Error loading photo: \(error.localizedDescription)")
            return nil
        }
    }
}
