//
//  MealPlanPageView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 7/1/23.
//

import SwiftUI

struct MealPlanPageView<T: MealPlanTabViewModelProtocol>: View {
    
    @ObservedObject var viewModel: T
    
    var body: some View {
        TabView {
                ForEach(viewModel.mealPlanArray) { plan in
                    MealPlanCardView(color: .gray.opacity(0.2), mealPlan: plan)
                        .padding(.horizontal)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

struct MealPlanPageView_Previews: PreviewProvider {
    
    class PreviewViewModel: MealPlanTabViewModelProtocol {
        var mealPlanArray: [MealPlan]
        
        func deleteMealPlan(_ mealPlan: MealPlan) {
            mealPlanArray.removeAll(where: {
                $0.id == mealPlan.id
            })
        }
        
        func createMealPlanViewModel(for: MealPlan) -> some MealPlanViewModelProtocol {
            MealPlanViewModel(mealPlan: mealPlanArray[0],
                                dataManager: DataManager.preview as MealPlanDataManagerProtocol)
        }
        init() {
            self.mealPlanArray = Array(repeating: SampleData.sampleMealPlan, count: 3)
        }
    }
    
    static var previews: some View {
        MealPlanPageView(viewModel: PreviewViewModel())
    }
}
