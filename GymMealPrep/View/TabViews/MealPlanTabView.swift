//
//  MealPlanTabView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/19/23.
//

import SwiftUI

struct MealPlanTabView: View {
    
    enum ViewType: String, CaseIterable {
        case list = "list"
        case card = "card"
        case tile = "tile"
    }
    
    @State var mealPlans: [MealPlan]
    @State var displayType: ViewType = .list
    @State var showTitleInline: Bool = true
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
            List {
                ForEach(mealPlans) { plan in
                    NavigationLink(value: plan) {
                        MealPlanRowView(mealPlan: plan)
                    }
                } // END OF FOR EACH
            } // END OF LIST
            .listStyle(.inset)
        case .card:
            Text("this is card view")
        case .tile:
            Text("this is tile view")
        } // END OF SWITCH
    }
    
}

struct MealPlanTabView_Previews: PreviewProvider {
    static var previews: some View {
        MealPlanTabView(mealPlans: Array(repeating: SampleData.sampleMealPlan, count: 1))
    }
}
