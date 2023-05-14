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
                    Image(systemName: "square.grid.2x2")
                        .font(.largeTitle)
                }
            
        } // END OF TABVIEW
    } // END OF BODY
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
