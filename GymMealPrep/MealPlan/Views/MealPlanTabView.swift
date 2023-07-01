//
//  MealPlanTabView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/19/23.
//

import SwiftUI

enum MealPlanTabNavigationState: Hashable {
    case showingMealPlanDetailView(MealPlan)
    case showingMealPlanEditingView(MealPlan)
}

struct MealPlanTabView<T: MealPlanTabViewModelProtocol>: View {
    
    enum ViewType: String, CaseIterable {
        case list = "List"
        case card = "Cards"
        case tile = "Tiles"
        
        func getIcon() -> String {
            switch self {
            case .list:
                return "text.justify"
            case .card:
                return "rectangle.portrait.on.rectangle.portrait.angled"
            case .tile:
                return "square.grid.2x2"
            }
        }
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
                                    Label(type.rawValue, systemImage: type.getIcon())
                                }
                            }
                            Divider()
                            Text("Sorting")
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }

                    }
                }
            
                .navigationDestination(for: MealPlanTabNavigationState.self) { state in
                    switch state {
                    case .showingMealPlanDetailView(let plan):
                        MealPlanCardView(color: .white, mealPlan: plan)
                    case .showingMealPlanEditingView(let plan):
                        MealPlanEditorView(viewModel: viewModel.createMealPlanViewModel(for: plan))
                    }
                }
        } // END OF NAV STACK
    } // END OF BODY
    @ViewBuilder
    var content: some View {
        switch displayType {
        case .list:
            MealPlanListView(viewModel: viewModel)
        case .card:
            MealPlanPageView(viewModel: viewModel)
        case .tile:
            MealPlanGridView(viewModel: viewModel)
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
        
        func createMealPlanViewModel(for: MealPlan) -> some MealPlanViewModelProtocol {
            MealPlanViewModel(mealPlan: mealPlanArray[0],
                                dataManager: DataManager.preview as MealPlanDataManagerProtocol)
        }
        init() {
            self.mealPlanArray = []
            for i in 0..<10 {
                mealPlanArray.append(MealPlan(name: "Sample Test Plan \(i)", meals: SampleData.sampleMealPlan.meals))
            }
        }
    }
    
    static var previews: some View {
        MealPlanTabView(viewModel: PreviewViewModel())
    }
}
