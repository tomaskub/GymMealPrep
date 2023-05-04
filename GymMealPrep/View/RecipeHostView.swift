//
//  RecipeHostView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/1/23.
//

import SwiftUI

struct RecipeHostView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var isEditing: Bool = false
    @StateObject private var viewModel: RecipeViewModel
    
    /// Initializer for a recipie view allowing to show and edit recipe
    /// - Parameter recipe: Recipie for the view to display and edit
    public init(recipe: Recipe) {
        self._viewModel = StateObject(wrappedValue: RecipeViewModel(recipe: recipe))
    }
    
    var body: some View {
        ZStack {
            
            if isEditing != true {
                RecipeView(viewModel: viewModel)
            } else {
                RecipeEditorView(viewModel: viewModel)
            }
            
        }// END OF ZSTACK
        // hide default toolbar background + back button
        .toolbarBackground(.hidden, for: .automatic)
        .navigationBarBackButtonHidden()
        // custom toolbar
            .toolbar {
                
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
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
                        dismiss()
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
            RecipeHostView(recipe: SampleData.recipieCilantroLimeChicken)
        }
    }
}
