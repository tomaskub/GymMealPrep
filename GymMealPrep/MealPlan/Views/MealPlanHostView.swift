//
//  MealPlanHostView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 7/1/23.
//

import SwiftUI

struct MealPlanHostView: View {
    
    @ObservedObject var viewModel: MealPlanViewModel
    @State var isEditing: Bool = false
    
    var body: some View {
        ZStack {
            if isEditing {
                MealPlanEditorView(viewModel: viewModel)
            } else {
                MealPlanDetailView(viewModel: viewModel)
            }
        }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isEditing.toggle()
                    } label: {
                        Text(isEditing ? "Done" : "Edit")
                    }
                }
            }
    }
}

struct MealPlanHostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MealPlanHostView(
                viewModel: MealPlanViewModel(mealPlan: SampleData.sampleMealPlan,
                                             dataManager: DataManager.preview))
        }
    }
}
