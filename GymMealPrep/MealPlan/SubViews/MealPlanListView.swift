//
//  MealPlanListView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/30/23.
//

import SwiftUI

struct MealPlanListView<T: MealPlanTabViewModelProtocol>: View {
    @ObservedObject var viewModel: T
    
    var body: some View {
        List {
            ForEach(viewModel.mealPlanArray) { plan in
                NavigationLink(value: MealPlanTabNavigationState.showingMealPlanDetailView(plan)) {
                    MealPlanRowView(mealPlan: plan)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    
                    Button(role: .destructive) {
                        viewModel.deleteMealPlan(plan)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    
                    NavigationLink(value: MealPlanTabNavigationState.showingMealPlanEditingView(plan)) {
                        Label("Edit", systemImage: "pencil")
                    }
                }// END OF SWIPE ACTIONS
            } // END OF FOR EACH
        } // END OF LIST
        .listStyle(.inset)
    }
}

struct MealPlanListView_Previews: PreviewProvider {
    
    class PreviewViewModel: MealPlanTabViewModelProtocol {
        var mealPlanArray: [MealPlan]
        
        func deleteMealPlan(_ mealPlan: MealPlan) {
            mealPlanArray.removeAll(where: {
                $0.id == mealPlan.id
            })
        }
        
        func createMealPlanViewModel(for: MealPlan) -> any MealPlanViewModelProtocol {
            MealPlanViewModel(mealPlan: mealPlanArray[0],
                                dataManager: DataManager.preview as MealPlanDataManagerProtocol)
        }
        init() {
            self.mealPlanArray = Array(repeating: SampleData.sampleMealPlan, count: 1)
        }
        
    }
    
    static var previews: some View {
        NavigationStack {
            MealPlanListView(viewModel: PreviewViewModel())
        }
    }
}
