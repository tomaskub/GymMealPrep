//
//  RecipeCreatorHostView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/14/23.
//

import SwiftUI

struct RecipeCreatorHostView: View, KeyboardReadable {
    
    enum Stage: CaseIterable {
        case webLinkEntry
        case dataEntry
        case ingredientParsing
        case instructionParsing
        case confirmation
    }
    
    @StateObject private var viewModel: RecipeCreatorViewModelProtocol
    @State private var displayedStage: Stage
    @State private var processStage: Stage
    @State private var isShowingStageControls: Bool = true
    @Binding var path: NavigationPath
    
    private let includeWebLink: Bool
    let stageTransition: AnyTransition = {
        AnyTransition.asymmetric(
            insertion: .push(from: .trailing),
            removal: .move(edge: .leading))
    }()
    
    init(viewModel: RecipeCreatorViewModelProtocol, path: Binding<NavigationPath>, includeWebLink: Bool = false) {
        self._viewModel = StateObject.init(wrappedValue: viewModel)
        self.includeWebLink = includeWebLink
        self._path = path
        
        if includeWebLink {
            self._displayedStage = State.init(initialValue: .webLinkEntry)
            self._processStage = State.init(initialValue: .webLinkEntry)
        } else {
            self._displayedStage = State.init(initialValue: .dataEntry)
            self._processStage = State.init(initialValue: .dataEntry)
        }
    }
    
    //MARK: BODY
    var body: some View {
                VStack {
                    switch displayedStage {
                    case .webLinkEntry:
                        RecipeCreatorWebLinkView(viewModel: viewModel)
                    case .dataEntry:
                        RecipeCreatorView(viewModel: viewModel,
                                          isShowingInstructionTooltip: !includeWebLink,
                                          isShowingIngredientsTooltip: !includeWebLink)
                            .transition(stageTransition)
                    case .ingredientParsing:
                        RecipeCreatorParserView(viewModel: viewModel, saveHandler: viewModel)
                            .transition(stageTransition)
                    case .instructionParsing:
                        RecipeCreatorInstructionsView(viewModel: viewModel)
                            .transition(stageTransition)
                    case .confirmation:
                        RecipeCreatorConfirmationView(viewModel: viewModel)
                            .transition(stageTransition)
                    }
                    if isShowingStageControls {
                        stageControls
                    }
                } // END OF VSTACK
                .overlay {
                    if viewModel.isProcessingData {
                        LoadingView(actionText: viewModel.processName)
                    }
                }
                .onReceive(keyboardPublisher, perform: { isKeyboardVisible in
                    isShowingStageControls = !isKeyboardVisible
                })
                .alert(viewModel.alertTitle, isPresented: $viewModel.isShowingAlert) {
                    Button("OK") {
                        viewModel.isShowingAlert.toggle()
                        viewModel.clearAlertMessage()
                    }
                } message: {
                    Text(viewModel.alertMessage)
                }
            .toolbar(.hidden, for: .tabBar)
    } // END OF BODY

    var stageControls: some View {
        HStack {
            Spacer()
            Text(buttonText)
                .accessibilityIdentifier("advance-stage-button")
                .font(.title3)
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                .background(.blue)
                .cornerRadius(8)
                .onTapGesture {
                    advanceStage()
                } // END OF ON TAP GESTURE
            if displayedStage == .confirmation {
                Text("Save and open")
                    .accessibilityIdentifier("save-and-open-button")
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
                if isDisplayingPreviousStageButton {
                    Image(systemName: "chevron.left")
                        .accessibilityIdentifier("back-button")
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
                if isDisplayingPreviousStage && displayedStage != .confirmation {
                        Image(systemName: "chevron.right")
                        .accessibilityIdentifier("next-button")
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
    
// MARK: COMPUTED PROPERTIES
    var isDisplayingPreviousStage: Bool {
        guard let displayedStageIndex = Stage.allCases.firstIndex(of: displayedStage),
              let processStageIndex = Stage.allCases.firstIndex(of: processStage) else {
            fatalError("Fatal error encountered at: \(#file)\n at line: \(#file)\n displayedStage or process stage was not foung in all cases of Stage enum")
        }
        return displayedStageIndex < processStageIndex
    }
    
    var buttonText: String {
        switch displayedStage {
        case .webLinkEntry:
            return "Get recipe from link"
        case .dataEntry:
            return "Match ingredients"
        case .ingredientParsing:
            return "Confirm ingredients"
        case .instructionParsing:
            return "Confirm instructions"
        case .confirmation:
            return "Save and exit"
        }
    }
    
    var isDisplayingPreviousStageButton: Bool {
        return !includeWebLink ? displayedStage != .dataEntry : (displayedStage != .webLinkEntry)
    }
} // END OF STRUCT

// MARK: STAGE CONTROL & NAVIGATION FUNCTIONS
extension RecipeCreatorHostView {
    
    func advanceStage() {
        if processStage != displayedStage {
            processStage = displayedStage
        }
        switch processStage {
        case .webLinkEntry:
                viewModel.processLink()
            if !viewModel.isShowingAlert {
                withAnimation {
                    displayedStage = displayedStage.next()
                }
                processStage = processStage.next()
            }
        case .dataEntry:
            viewModel.processInput()
            if !viewModel.isShowingAlert {
                withAnimation {
                    displayedStage = displayedStage.next()
                }
                processStage = processStage.next()
            }
        case .confirmation:
            _ = viewModel.saveRecipe()
            path = NavigationPath()
        default:
            withAnimation {
                displayedStage = displayedStage.next()
            }
            processStage = processStage.next()
        }
    }
    
    func regressDisplayedStage() {
        if !includeWebLink && displayedStage.previous() == .webLinkEntry {
            withAnimation {
                displayedStage = displayedStage.previous().previous()
            }
        } else {
            withAnimation {
                displayedStage = displayedStage.previous()
            }
        }
    }
    
    func advanceDisplayedStage() {
        withAnimation {
            displayedStage = displayedStage.next()
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
    struct ContainerView: View {
        @StateObject private var container: Container = .init()
        var body: some View {
            NavigationStack {
                RecipeCreatorHostView(viewModel: RecipeCreatorViewModel(dataManager: container.dataManager,
                                                                        networkController: container.networkController),
                                      path: .constant(NavigationPath()),
                                      includeWebLink: true)
            }
            .environmentObject(container)
        }
    }
    static var previews: some View {
        ContainerView()
    }
}
