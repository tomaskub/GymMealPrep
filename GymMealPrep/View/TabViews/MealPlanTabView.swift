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

    @State var displayType: ViewType = .tile
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
                        MealPlanEditorView(draftMealPlan: plan)
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
            TabView{
                
                    ForEach(viewModel.mealPlanArray) { plan in
                        MealPlanCardView(color: .gray.opacity(0.2), mealPlan: plan)
                            .padding(.horizontal)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            
        case .tile:
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(viewModel.mealPlanArray) { plan in
                        Text(plan.name ?? "No name")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                    }
                }
            }
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
            self.mealPlanArray = Array(repeating: SampleData.sampleMealPlan, count: 3)
        }
        
    }
    
    static var previews: some View {
        MealPlanTabView(viewModel: PreviewViewModel())
    }
}
