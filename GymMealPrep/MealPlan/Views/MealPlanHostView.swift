//
//  MealPlanHostView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 7/1/23.
//

import SwiftUI

struct MealPlanHostView: View {
    
    @ObservedObject var viewModel: MealPlanViewModel
    @Binding var navigationPath: NavigationPath
    @State var isEditing: Bool = false
    @State var isAddingNewMealPlan: Bool = false
    
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
        if isAddingNewMealPlan {
         return "Adding new meal plan"
        }
        return "Editing meal plan"
    }
}

struct MealPlanHostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MealPlanHostView(
                viewModel: MealPlanViewModel(mealPlan: SampleData.sampleMealPlan,
                                             dataManager: DataManager.preview),
                navigationPath: .init(get: {
                    return NavigationPath()
                }, set: { navPath in
                    print(navPath)
                })
                                            )
        }
    }
}
