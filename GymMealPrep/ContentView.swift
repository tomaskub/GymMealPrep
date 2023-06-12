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
            NavigationView {
                RecipeListView()
            }
                    .tabItem {
                        Image(systemName: "square.fill.text.grid.1x2")
                            .font(.largeTitle)
                        Text("Recipe list")
                    }
            
            //Easy access for testing
            NavigationView {
                RecipeCreatorView()
            }
            .tabItem {
                Image(systemName: "rectangle.grid.1x2.fill")
                    .font(.largeTitle)
                Text("Recipe Creator Test")
            }
            
            Text("Settings placeholder")
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
