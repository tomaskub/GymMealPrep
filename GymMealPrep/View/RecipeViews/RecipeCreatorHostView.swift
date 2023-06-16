//
//  RecipeCreatorHostView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/14/23.
//

import SwiftUI

struct RecipeCreatorHostView: View {
    @StateObject private var viewModel: RecipeCreatorViewModelProtocol = RecipeCreatorViewModel()
    @State private var stage: Int = 0
    @Binding var path: NavigationPath
    
    let stageTransition: AnyTransition = {
        AnyTransition.asymmetric(
            insertion: .push(from: .trailing),
            removal: .move(edge: .leading))
    }()
    
    var body: some View {
        VStack {
            switch stage {
            case 0:
                RecipeCreatorView(viewModel: viewModel)
                    .transition(stageTransition)
            case 1:
                RecipeCreatorParserView(viewModel: viewModel, saveHandler: viewModel)
                    .transition(stageTransition)
            case 2:
                RecipeCreatorInstructionsView(viewModel: viewModel)
                    .transition(stageTransition)
            case 3:
                RecipeCreatorConfirmationView(viewModel: viewModel)
                    .transition(stageTransition)
            default:
                Text("This is default case for switch statement")
            }
            HStack {
                Spacer()
                Text(buttonText)
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    .background(.blue)
                    .cornerRadius(8)
                    .onTapGesture {
                        switch stage {
                        case 0:
                            viewModel.processInput()
                            withAnimation {
                                stage += 1
                            }
                        case 3:
                            _ = viewModel.saveRecipe()
                            path = NavigationPath()
                        default:
                            withAnimation {
                                stage += 1
                            }
                        }
                    } // END OF ON TAP GESTURE
                if stage == 3 {
                    Text("Save and open")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .background(.blue)
                        .cornerRadius(8)
                        .transition(.opacity)
                        .onTapGesture {
                            let recipe = viewModel.saveRecipe()
                            var newPath = NavigationPath()
                            newPath.append(RecipeListTabView.NavigationState.showingRecipeDetailEdit(recipe))
                            path = newPath
                        }
                }
                Spacer()
            } // END OF HSTACK
            .overlay(alignment: .leading) {
                HStack {
                    if stage != 0 {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.title3)
                            .padding(.all, 10)
                            .background(.blue)
                            .cornerRadius(8)
                            .onTapGesture {
                                withAnimation {
                                    stage -= 1
                                }
                            }
                            .transition(.opacity)
                    }
                    Spacer()
                    
                }
                .padding(.horizontal, 10)
            }
        } // END OF VSTACK
        .toolbar(.hidden, for: .tabBar)
    } // END OF BODY
    
    var buttonText: String {
        switch stage {
        case 0:
            return "Match ingredients"
        case 1:
            return "Confirm and edit instructions"
        case 2:
            return "Confirm Instructions"
        case 3:
            return "Save and exit"
        default:
            return String()
        }
    }
} // END OF STRUCT

struct RecipeCreatorHostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RecipeCreatorHostView(path: .constant(NavigationPath()))
        }
    }
}
