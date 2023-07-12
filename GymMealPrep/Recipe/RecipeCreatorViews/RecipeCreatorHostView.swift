//
//  RecipeCreatorHostView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/14/23.
//

import SwiftUI

struct RecipeCreatorHostView: View {
    @StateObject private var viewModel: RecipeCreatorViewModelProtocol = RecipeCreatorViewModel()
    @State private var displayedStage: Int = 0
    @State private var processStage: Int = 0
    
    @Binding var path: NavigationPath
    
    let stageTransition: AnyTransition = {
        AnyTransition.asymmetric(
            insertion: .push(from: .trailing),
            removal: .move(edge: .leading))
    }()
    
    //MARK: BODY
    var body: some View {
        ScrollView {
                VStack {
                    switch displayedStage {
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
                        Text(String())
                    }
                    stageControls
                } // END OF VSTACK
            } // END OF SCROLL VIEW
            .toolbar(.hidden, for: .tabBar)
    } // END OF BODY

    var stageControls: some View {
        HStack {
            Spacer()
            Text(buttonText)
                .font(.title3)
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                .background(.blue)
                .cornerRadius(8)
                .onTapGesture {
                    advanceStage()
                } // END OF ON TAP GESTURE
            if displayedStage == 3 {
                Text("Save and open")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    .background(.blue)
                    .cornerRadius(8)
                    .transition(.opacity)
                    .onTapGesture {
                        saveAndOpen()
                    }
            }
            Spacer()
        } // END OF HSTACK
        .overlay(alignment: .leading) {
            HStack {
                if displayedStage != 0 {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.title3)
                        .padding(.all, 10)
                        .background(.blue)
                        .cornerRadius(8)
                        .onTapGesture {
                            regressDisplayedStage()
                        }
                        .transition(.opacity)
                }
                Spacer()
                if displayedStage < processStage && displayedStage != 3 {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                            .font(.title3)
                            .padding(.all, 10)
                            .background(.blue)
                            .cornerRadius(8)
                            .onTapGesture {
                                advanceDisplayedStage()
                            }
                            .transition(.opacity)
                    }
            }
            .padding(.horizontal, 10)
        }
    }
    
    var buttonText: String {
        switch displayedStage {
        case 0:
            return "Match ingredients"
        case 1:
            return "Confirm ingredients"
        case 2:
            return "Confirm instructions"
        case 3:
            return "Save and exit"
        default:
            return String()
        }
    }
} // END OF STRUCT

// MARK: STAGE NAV FUNCTIONS
extension RecipeCreatorHostView {
    
    func advanceStage() {
       
        if processStage != displayedStage {
            processStage = displayedStage
        }
        
        switch processStage {
        case 0:
            viewModel.processInput()
            withAnimation {
                displayedStage += 1
            }
            processStage += 1
        case 3:
            _ = viewModel.saveRecipe()
            path = NavigationPath()
        default:
            withAnimation {
                displayedStage += 1
            }
            processStage += 1
        }
    }
    
    func regressDisplayedStage() {
        withAnimation {
            displayedStage -= 1
        }
    }
    
    func advanceDisplayedStage() {
        withAnimation {
            displayedStage += 1
        }
    }
    
    func saveAndOpen() {
        let recipe = viewModel.saveRecipe()
        var newPath = NavigationPath()
        newPath.append(RecipeListTabView.NavigationState.showingRecipeDetailEdit(recipe))
        path = newPath
    }
}

struct RecipeCreatorHostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RecipeCreatorHostView(path: .constant(NavigationPath()))
        }
    }
}
