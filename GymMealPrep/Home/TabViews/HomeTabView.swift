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
                    HStack {
                        Text("Pick your plan for next week and make sure to pick up your groceries")
                        Image(systemName: "chevron.right")
                    }
                } header: {
                    Text("Saturday")
                        .font(.title3)
                        .foregroundColor(.primary)
                        .underline(color: .green)
                }
                
                Section {
                    createMealRow(mealName: "Breakfast", meals: ["Skyr", "100 g of strawberries" ,"Becon and egg burrito"])
                    createMealRow(mealName: "Lunch", meals: ["Sweet and sour chicken", "90 g of rice"])
                    createMealRow(mealName: "Dinner", meals: ["Tomato basil sausage spaghetti recipe"])
                } header: {
                    Text("Sunday")
                        .font(.title3)
                        .foregroundColor(.primary)
                        .underline(color: .green)
                }
                Section {
                    createMealRow(mealName: "Breakfast", meals: ["Skyr", "100 g of strawberries" ,"Becon and egg burrito"])
                    createMealRow(mealName: "Lunch", meals: ["Sweet and sour chicken", "90 g of rice"])
                    createMealRow(mealName: "Dinner", meals: ["Tomato basil sausage spaghetti recipe"])
                } header: {
                    Text("Monday")
                        .font(.title3)
                        .foregroundColor(.primary)
                        .underline(color: .green)
                }
            }
            
                .navigationTitle("Current week")
        }
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
