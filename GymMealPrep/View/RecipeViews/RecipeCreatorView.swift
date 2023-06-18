//
//  RecipeCreatorView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/27/23.
//

import SwiftUI

struct RecipeCreatorView: View {
    
    @ObservedObject var viewModel: RecipeCreatorViewModelProtocol
    @State var isShowingInstructionTooltip: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            
            TextField("Recipe titile", text: $viewModel.recipeTitle)
                .font(.title3)
                .fontWeight(.semibold)
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(20)
            
            HStack {
                Text("Ingredients:")
                    .fontWeight(.semibold)
                    .font(.title3)
                Spacer()
                Stepper("\(viewModel.servings) \(stepperLabel)", value: $viewModel.servings)
                    .fixedSize()
            }
            
            TextEditor(text: $viewModel.ingredientsEntry)
                .scrollContentBackground(.hidden)
                .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                .background(.gray.opacity(0.1))
                .cornerRadius(20)
            
            HStack {
                
                Text("Instructions:")
                    .fontWeight(.semibold)
                    .font(.title3)
                    
                Image(systemName: "info")
                    .padding(.all, 5)
                    .background(
                    Circle()
                        .foregroundColor(.gray.opacity(0.2)))
                    .onTapGesture {
                        withAnimation {
                            isShowingInstructionTooltip.toggle()
                        }
                    }
            } // END OF HSTACK
            
            TextEditor(text: $viewModel.instructionsEntry)
                .scrollContentBackground(.hidden)
                .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                .background(.gray.opacity(0.1))
                .cornerRadius(20)
                .overlay {
                    if isShowingInstructionTooltip {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Tip:")
                                .fontWeight(.semibold)
                            Text("Use numbers to start new instruction to make sure the translation is sucessful.")
                                .multilineTextAlignment(.leading)
                            //                            .padding(.horizontal)
                            Text("Example:")
                                .fontWeight(.semibold)
                            Text("1. First sample instruction.\n2. Second dample instruction")
                        } // END OF VSTACK
                        .padding()
                        .background(
                            Color.white
                        )
                        .cornerRadius(20)
                        .transition(.opacity)
                    } // END OF IF CONDITION
                } // END OF OVERLAY
        } // END OF VSTACK
        .padding()
        .navigationTitle("Create recipe")
    } // END OF BODY
    var stepperLabel: String {
        viewModel.servings > 1 ? "servings" : "serving"
    }
} // END OF STRUCT


struct RecipeCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeCreatorView(viewModel: RecipeCreatorViewModel())
        }
    }
}
