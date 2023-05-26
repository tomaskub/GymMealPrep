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
            
            RecipeListView()
                .tabItem {
                    Image(systemName: "square.fill.text.grid.1x2")
                        .font(.largeTitle)
                    Text("Recipe list")
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
