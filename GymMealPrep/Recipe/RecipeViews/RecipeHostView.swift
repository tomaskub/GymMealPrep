//
//  RecipeHostView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/1/23.
//

import SwiftUI

struct RecipeHostView: View {
    
    @State var isEditing: Bool = false
    @StateObject var viewModel: RecipeViewModel
    @Binding var path: NavigationPath
    
    init(isEditing: Bool, recipe: Recipe, dataManager: DataManager = DataManager.shared, path: Binding<NavigationPath>) {
        self._viewModel = StateObject(wrappedValue: RecipeViewModel(recipe: recipe, dataManager: dataManager))
        self._path = path
        self.isEditing = isEditing
    }
    
    var body: some View {
        ZStack {
            
            if isEditing != true {
                RecipeView(viewModel: viewModel)
            } else {
                RecipeEditorView(viewModel: viewModel)
            }
            
        }// END OF ZSTACK
        
        // hide default toolbar background + back button to manage the material
        .toolbarBackground(.hidden, for: .automatic)
        .navigationBarBackButtonHidden()
        // custom toolbar
            .toolbar {
                
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            if isEditing {
                                viewModel.saveRecipe()
                            }
                            isEditing.toggle()
                        } label: {
                            Text(isEditing ? "Done" : "Edit")
                                .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                                .background(Material.bar)
                                .cornerRadius(4)
                        }
                    }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        path.removeLast()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                            .background(Material.bar)
                            .cornerRadius(4)
                    }
                } // END OF TOOLBARITEM
            }// END OF TOOLBAR
        
    }
}

struct RecipeHostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeHostView(
                isEditing: false,
                recipe: SampleData.recipieCilantroLimeChicken,
                dataManager: .preview,
                path:.constant(NavigationPath())
            )
        }
    }
}
