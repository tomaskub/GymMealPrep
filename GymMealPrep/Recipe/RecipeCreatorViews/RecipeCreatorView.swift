//
//  RecipeCreatorView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/27/23.
//

import SwiftUI

struct RecipeCreatorView: View {
    
    private enum Focusable: Hashable, CaseIterable {
        case title, ingredients, instructions
    }
    
    @ObservedObject var viewModel: RecipeCreatorViewModelProtocol
    
    @State var isShowingInstructionTooltip: Bool = true
    @State var isShowingIngredientsTooltip: Bool = true
    @FocusState private var textFieldInFocus: Focusable?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                TextField("Recipe title", text: $viewModel.recipeTitle)
                    .accessibilityIdentifier("recipe-title-text-field")
                    .focused($textFieldInFocus, equals: .title)
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
                        .accessibilityIdentifier("servings-quantity-stepper")
                }
                
                TextEditor(text: $viewModel.ingredientsEntry)
                    .accessibilityIdentifier("ingredients-text-field")
                    .focused($textFieldInFocus, equals: .ingredients)
                    .scrollContentBackground(.hidden)
                    .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                    .background(.gray.opacity(0.1))
                    .cornerRadius(20)
                    .frame(minHeight: 200)
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
                            .accessibilityIdentifier("ingredients-tool-tip")
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
                    .accessibilityIdentifier("instructions-text-field")
                    .focused($textFieldInFocus, equals: .instructions)
                    .scrollContentBackground(.hidden)
                    .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                    .background(.gray.opacity(0.1))
                    .cornerRadius(20)
                    .frame(minHeight: 200)
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
                            .accessibilityIdentifier("instructions-tool-tip")
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
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    if textFieldInFocus != .title && textFieldInFocus != nil {
                        Button("Back") {
                            if let focused = textFieldInFocus {
                                switch focused {
                                case .title: break // cant be true if button is present
                                case .ingredients:
                                    textFieldInFocus = .title
                                case .instructions:
                                    textFieldInFocus = .ingredients
                                }
                            }
                        }
                    }
                    Spacer()
                    Button(textFieldInFocus != .instructions ? "Next" : "Finish") {
                        if let focused = textFieldInFocus {
                            switch focused {
                            case .title:
                                textFieldInFocus = .ingredients
                            case .ingredients:
                                textFieldInFocus = .instructions
                            case .instructions:
                                textFieldInFocus = nil
                            }
                        }
                    }
                } // END OF TOOLBAR ITEM GROUP
            } // END OF TOOLBAR
        } // END OF SCROLLVIEW
    } // END OF BODY
    var stepperLabel: String {
        viewModel.servings > 1 ? "servings" : "serving"
    }
} // END OF STRUCT


struct RecipeCreatorView_Previews: PreviewProvider {
    struct PreviewContainer: View {
        @StateObject private var container: Container = .init()
        var body: some View {
            NavigationView {
                RecipeCreatorView(viewModel: RecipeCreatorViewModel(dataManager: container.dataManager, networkController: container.networkController))
                    .environmentObject(container)
            }
        }
    }
    static var previews: some View {
        PreviewContainer()
    }
}
