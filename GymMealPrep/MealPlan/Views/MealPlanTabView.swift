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
    case showingMealPlanAddingView(MealPlan)
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
    @EnvironmentObject private var container: Container
    @StateObject private var viewModel: T
    @State private var navigationPath = NavigationPath()
    @State private var displayType: ViewType = .list
    @State private var showTitleInline: Bool = true
    
    public init(viewModel: T) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        NavigationStack {
            
            content
                .navigationTitle("Meal plans")
                .navigationBarTitleDisplayMode(showTitleInline ? .inline : .large)
                .toolbar {
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(value: MealPlanTabNavigationState.showingMealPlanAddingView(MealPlan(meals: []))) {
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
                        MealPlanHostView(viewModel: MealPlanViewModel(mealPlan: plan,
                                                                      dataManager: container.dataManager),
                                         navigationPath: $navigationPath)
                    case .showingMealPlanEditingView(let plan):
                        MealPlanHostView(viewModel: MealPlanViewModel(mealPlan: plan,
                                                                      dataManager: container.dataManager),
                                         navigationPath: $navigationPath,
                                         isEditing: true)
                    case .showingMealPlanAddingView(let plan):
                        MealPlanHostView(viewModel: MealPlanViewModel(mealPlan: plan,
                                                                      dataManager: container.dataManager),
                                         navigationPath: $navigationPath,
                                         isEditing: true,
                                         isAddingNewMealPlan: true)
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
