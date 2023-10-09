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
            
            HomeTabView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            Text("Logging placeholder")
                .tabItem {
                    Image(systemName: "pencil.line")
                    Text("Log")
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
            
            Text("Settings placeholder")
                .tabItem {
                    Image(systemName: "gearshape")
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
