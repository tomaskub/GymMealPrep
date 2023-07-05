//
//  MealPlanEditorSheetView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 7/2/23.
//

import SwiftUI

struct MealPlanEditorSheetView: View {
    
    typealias MealPlanEditorSaveHandler = RecipeSaveHandler & IngredientSaveHandler
    var saveHandler: MealPlanEditorSaveHandler
    
    private enum ContentType: String, CaseIterable {
        case ingredient = "Adding ingredient"
        case recipe = "Adding Recipe"
    }
    @State private var selected: ContentType = .ingredient
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        
            VStack {
                
                    Picker("Type", selection: $selected) {
                        ForEach(ContentType.allCases, id: \.rawValue) { type in
                            Text(type.rawValue).tag(type)
                                .padding(.vertical, 4)
                        } // END OF FOR EACH
                    } // END OF PICKER
                    .pickerStyle(.segmented)
                
                switch selected {
                case .ingredient:
                    IngredientHostView(title: "Add new ingredient",
                                       buttonTitle: "Add manually",
                                       saveHandler: saveHandler,
                                       pickerViewModel: IngredientPickerViewModel())
                case .recipe:
                    RecipePickerView(saveHandler: saveHandler,
                                     viewModel: RecipePickerViewModel(dataManager: .preview))
                } // END OF SWITCH
            } // END OF VSTACK
    } // END OF BODY
} // END OF STRUCT
struct MealPlanEditorSheetView_Previews: PreviewProvider {
    class PreviewSaveHandler: RecipeSaveHandler, IngredientSaveHandler {
        func addRecipe(_: Recipe) {
            //do nothing
        }
        
        func addIngredient(_: Ingredient, _: String?) {
            //do nothing
        }
    }
    
    static var previews: some View {
        NavigationStack {
            Text("Preview")
                .sheet(isPresented: .constant(true)) {
                    MealPlanEditorSheetView(saveHandler: PreviewSaveHandler(), navigationPath: .constant(NavigationPath()))
                }
        }
        
    }
}
