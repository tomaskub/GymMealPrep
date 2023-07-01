//
//  RecipeCreatorView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/27/23.
//

import SwiftUI

struct RecipeCreatorView: View {
    
    @ObservedObject var viewModel: RecipeCreatorViewModelProtocol
    
    @State var isShowingInstructionTooltip: Bool = true
    @State var isShowingIngredientsTooltip: Bool = true
    
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
                Image(systemName: "info")
                    .padding(.all, 5)
                    .background(
                    Circle()
                        .foregroundColor(.gray.opacity(0.2)))
                    .onTapGesture {
                        withAnimation {
                            isShowingIngredientsTooltip.toggle()
                        }
                    }
                Spacer()
                Stepper("\(viewModel.servings) \(stepperLabel)", value: $viewModel.servings)
                    .fixedSize()
            }
            
            TextEditor(text: $viewModel.ingredientsEntry)
                .scrollContentBackground(.hidden)
                .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                .background(.gray.opacity(0.1))
                .cornerRadius(20)
                .overlay {
                    if isShowingIngredientsTooltip {
                        VStack(alignment: .leading, spacing: 5) {
                            
                            Text("Tip:")
                                .fontWeight(.semibold)
                            
                            Text("Write the ingredients in natural way, starting with quantity, unit of measure and then the name. Each ingredient should be in their own line.")
                                .multilineTextAlignment(.leading)
                            
                            Text("Example:")
                                .fontWeight(.semibold)
                            
                            Text("2 slices of bacon\n1 egg")
                        } // END OF VSTACK
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(lineWidth: 5)
                                .background(
                                    Color.white
                                )
                        )
                        .cornerRadius(20)
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation {
                                isShowingIngredientsTooltip.toggle()
                            }
                        }
                    } // END OF IF CONDITION
                }
            
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
                            
                            Text("Example:")
                                .fontWeight(.semibold)
                            
                            Text("1. First sample instruction.\n2. Second dample instruction")
                        } // END OF VSTACK
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(lineWidth: 5)
                                .background(
                                    Color.white
                                )
                        )
                        .cornerRadius(20)
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation {
                                isShowingInstructionTooltip.toggle()
                            }
                        }
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
