//
//  HomeTabView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/14/23.
//

import SwiftUI

struct HomeTabView: View {
    var body: some View {
        NavigationStack {
            List {
                
                Section {
                    NavigationLink(value: String("Meal")) {
                        Label("Assign meal plan for next period",systemImage: "calendar")
                    }
                    NavigationLink(value: String("Groceries")) {
                        Label("Generate shopping list", systemImage: "list.bullet")
                    }
                    NavigationLink(value: String("Cooking book")) {
                        Label("Create cooking instructions", systemImage: "book.closed")
                    }
                } header: {
                    makeHeader(text: "Actions")
                }
                
                Section {
                    createMealRow(mealName: "Breakfast", meals: ["Skyr", "100 g of strawberries" ,"Becon and egg burrito"])
                    createMealRow(mealName: "Lunch", meals: ["Sweet and sour chicken", "90 g of rice"])
                    createMealRow(mealName: "Dinner", meals: ["Tomato basil sausage spaghetti recipe"])
                } header: {
                    makeHeader(text: "Today")
                }
                
            }
            
                .navigationTitle("Current week")
        }
    }
    
    @ViewBuilder
    private func makeHeader(text: String) -> some View {
        Text(text)
            .font(.title3)
            .foregroundColor(.primary)
            .underline(color: .green)
    }
    
    @ViewBuilder
    private func createMealRow(mealName: String, meals: [String]) -> some View {
        VStack(alignment: .leading) {
            Text(mealName + " - 500 cal")
            ForEach(meals, id: \.self) { meal in
                Text(meal)
            }
        }
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView()
    }
}
