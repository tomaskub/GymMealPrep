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
                RecipeCreatorConfirmationView()
                    .transition(stageTransition)
            default:
                Text("This is default case for switch statement")
            }
            HStack {
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
                        default:
                            print("finished!")
                        }
                        if stage != 3 {
                            withAnimation {
                                stage += 1
                            }
                        } else {
                            path = NavigationPath()
                        }
                    } // END OF ON TAP GESTURE
            } // END OF HSTACK
        } // END OF VSTACK
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
            return "Save recipe!"
        default:
            return "Default"
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
