//
//  MealPlanTabView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/19/23.
//

import SwiftUI

struct MealPlanTabView<T: MealPlanTabViewModelProtocol>: View {
    
    enum ViewType: String, CaseIterable {
        case list = "list"
        case card = "card"
        case tile = "tile"
    }
    
    @StateObject var viewModel: T

    @State var displayType: ViewType = .list
    @State var showTitleInline: Bool = true
    
    public init(viewModel: T = MealPlanTabViewModel()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        NavigationStack {
            
            content
                .navigationTitle("Meal plans")
                .navigationBarTitleDisplayMode(showTitleInline ? .inline : .large)
                .toolbar {
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(value: MealPlan(meals: [])) {
                            Image(systemName: "plus.circle")
                        }
                        
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        Menu {
                            ForEach(ViewType.allCases, id: \.rawValue) { type in
                                Button {
                                    displayType = type
                                } label: {
                                    Text(type.rawValue)
                                }
                            }
                            Divider()
                            Text("Sort by date")
                            Text("Sort by total calories")
                            Text("Sort by date")
                            Text("Sort by date")
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }

                    }
                    
                }
                    
                        
                .navigationDestination(for: MealPlan.self) { plan in
                    MealPlanEditorView(draftMealPlan: plan)
                }
        } // END OF NAV STACK
    } // END OF BODY
    @ViewBuilder
    var content: some View {
        switch displayType {
        case .list:
            MealPlanListView(viewModel: viewModel)
        case .card:
            Text("this is card view")
        case .tile:
            Text("this is tile view")
        } // END OF SWITCH
    } // END OF CONTENT
    
}

struct MealPlanTabView_Previews: PreviewProvider {
    
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
        MealPlanTabView(viewModel: PreviewViewModel())
    }
}
