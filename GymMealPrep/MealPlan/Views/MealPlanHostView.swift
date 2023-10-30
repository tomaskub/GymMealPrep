//
//  MealPlanHostView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 7/1/23.
//

import SwiftUI

struct MealPlanHostView: View {
    @StateObject var viewModel: MealPlanViewModel
    @Binding var navigationPath: NavigationPath
    @State var isEditing: Bool = false
    @State var isAddingNewMealPlan: Bool = false  
    
    init(viewModel: MealPlanViewModel, navigationPath: Binding<NavigationPath>, isEditing: Bool = false, isAddingNewMealPlan: Bool = false) {
        self._viewModel = StateObject.init(wrappedValue: viewModel)
        self._navigationPath = navigationPath
        self._isEditing = State.init(initialValue: isEditing)
        self._isAddingNewMealPlan = State.init(initialValue: isAddingNewMealPlan)
    }
    
    var body: some View {
        ZStack {
            if isEditing {
                MealPlanEditorView(viewModel: viewModel, navigationPath: $navigationPath, title: provideEditingTitle())
            } else {
                MealPlanDetailView(viewModel: viewModel)
            }
        }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if isEditing == true {
                            viewModel.saveChanges()
                            isAddingNewMealPlan = false
                        }
                        isEditing.toggle()
                    } label: {
                        Text(isEditing ? "Done" : "Edit")
                    }
                }
            }
    }
    func provideEditingTitle() -> String {
        isAddingNewMealPlan ? "Adding new meal plan" : "Editing meal plan"
    }
}

struct MealPlanHostView_Previews: PreviewProvider {
    private struct PreviewContainerView: View {
        @StateObject private var container = ContainerFactory.build()
        @State private var navPath = NavigationPath()
        var body: some View {
            NavigationStack {
                MealPlanHostView(viewModel: MealPlanViewModel(mealPlan: SampleData.sampleMealPlan,
                                                              dataManager: container.dataManager),
                                 navigationPath: $navPath)
            }
        }
    }
    static var previews: some View {
        PreviewContainerView()
    }
}
