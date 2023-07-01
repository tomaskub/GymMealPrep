//
//  MealPlanGridView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/30/23.
//

import SwiftUI

struct MealPlanGridView<T: MealPlanTabViewModelProtocol>: View {
    
    @ObservedObject var viewModel: T
    
    let columns: [GridItem] = [GridItem(.adaptive(minimum: 120), spacing: nil, alignment: nil)]
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(viewModel.mealPlanArray) { mealPlan in
                    MealPlanTileView(mealPlan: mealPlan)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
            }
        }
    }
}

struct MealPlanGridView_Previews: PreviewProvider {
    
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
            self.mealPlanArray = [SampleData.sampleMealPlan]
            for i in 0..<6 {
                mealPlanArray.append(MealPlan(name: "Sample test plan \(i)", meals: SampleData.sampleMealPlan.meals))
            }
        }
        
    }
    
    static var previews: some View {
        NavigationStack {
            MealPlanGridView(viewModel: PreviewViewModel())
        }
        .padding()
    }
}
