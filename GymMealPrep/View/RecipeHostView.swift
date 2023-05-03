//
//  RecipeHostView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/1/23.
//

import SwiftUI

struct RecipeHostView: View {
    
    
    @Environment(\.editMode) var editMode
    @State var isEditing: Bool = false
    @StateObject var viewModel: RecipeViewModel
    var body: some View {
        ZStack {
            
            if isEditing != true {
                RecipeView(viewModel: viewModel)
                HStack {
                    Spacer()
                    VStack {
                        Button {
                            isEditing.toggle()
                        } label: {
                            Image(systemName: "pencil")
                                .font(.title3)
                                .foregroundColor(.white)
                                .background(
                                    Circle()
                                        .foregroundColor(.gray.opacity(0.8))
                                        .frame(width: 30, height: 30))
                        }
                        Spacer()
                    }
                }
                .padding()
            } else {
                RecipeEditorView(viewModel: viewModel)
            }
            
        }// END OF ZSTACK
            .toolbar {
                if isEditing {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isEditing.toggle()
                        } label: {
                            Image(systemName: "checkmark")
                                .font(.title3)
                                .foregroundColor(.white)
                                .background(
                                    Circle()
                                        .foregroundColor(.gray.opacity(0.8))
                                        .frame(width: 30, height: 30))
                        }
                    }
                }
            }// END OF TOOLBAR
        
    }
}

struct RecipeHostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeHostView(viewModel: RecipeViewModel(recipe: SampleData.recipieCilantroLimeChicken))
        }
    }
}
