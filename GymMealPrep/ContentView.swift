//
//  ContentView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//

import SwiftUI

struct ContentView: View {
    private typealias Identifier = ScreenIdentifier.ContentView
    @EnvironmentObject private var container: Container
    
    var body: some View {
        TabView {
            
            Text("Dashboard view placeholder")
                .tabItem {
                    Label("Home", 
                          systemImage: "house.fill")
                    .accessibilityIdentifier(Identifier.homeTabButton.rawValue)
                }
                
            
            RecipeListTabView()
                .tabItem {
                    Label("Recipes",
                          systemImage: "square.fill.text.grid.1x2")
                    .accessibilityIdentifier(Identifier.recipeListTabButton.rawValue)
                }
                
            MealPlanTabView()
                .tabItem {
                    Label("Meal plans",
                          systemImage: "rectangle.grid.1x2.fill")
                    .accessibilityIdentifier(Identifier.mealPlanTabButton.rawValue)
                }
                
            
            SettingsTabView(viewModel: SettingsViewModel(settingStore: container.settingStore))
                .tabItem {
                    Label("Settings",
                          systemImage: "gear")
                    .accessibilityIdentifier(Identifier.settingsTabButton.rawValue)
                }
        } // END OF TABVIEW
    } // END OF BODY
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Container())
    }
}
