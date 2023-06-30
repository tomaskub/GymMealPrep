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
                ForEach(1..<10) { _ in
                    MealPlanTile(mealPlan: viewModel.mealPlanArray[0])
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        
                }
            }
        }
    }
}

struct MealPlanTile: View {
    let mealPlan: MealPlan
    
    let formatter: NumberFormatter = {
       let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter
    }()
    
    var body: some View {
        Grid(alignment: .leading, verticalSpacing: 4) {
            GridRow {
                Text(mealPlan.name ?? "Unnamed plan")
                    .font(.body)
            }
            .gridCellColumns(2)
            
            GridRow {
            Text("Calories")
                    .foregroundColor(.gray)
                Text(formatedValue(mealPlan.nutrition.calories))
            }
            
            GridRow {
                Text("Fats")
                    .foregroundColor(.gray)
                Text(formatedValue(mealPlan.nutrition.fat))
            }
            
            GridRow {
                Text("Carbs")
                    .foregroundColor(.gray)
                Text(formatedValue(mealPlan.nutrition.carb))
            }
            
            GridRow {
                Text("Proteins")
                    .foregroundColor(.gray)
                Text(formatedValue(mealPlan.nutrition.protein))
            }
        } // END OF GRID
        .font(.caption)
    } // END OF BODY
    
    private func formatedValue(_ value: Float) -> String {
        formatter.string(from: NSNumber(value: value)) ?? "0.0"
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
        
        func createMealPlanViewModel(for: MealPlan) -> any MealPlanViewModelProtocol {
            MealPlanViewModel(mealPlan: mealPlanArray[0],
                                dataManager: DataManager.preview as MealPlanDataManagerProtocol)
        }
        init() {
            self.mealPlanArray = Array(repeating: SampleData.sampleMealPlan, count: 3)
        }
        
    }
    
    static var previews: some View {
        NavigationStack {
            MealPlanGridView(viewModel: PreviewViewModel())
        }
        .padding()
    }
}
