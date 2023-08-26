//
//  ContentView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            
            Text("Dashboard view placeholder")
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            RecipeListTabView()
                    .tabItem {
                        Image(systemName: "square.fill.text.grid.1x2")
                            .font(.largeTitle)
                        Text("Recipes")
                    }
            
            MealPlanTabView()
            .tabItem {
                Image(systemName: "rectangle.grid.1x2.fill")
                    .font(.largeTitle)
                Text("Meal plans")
            }
            
            SettingsTabView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        } // END OF TABVIEW
    } // END OF BODY
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
