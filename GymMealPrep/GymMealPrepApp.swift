//
//  GymMealPrepApp.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//

import SwiftUI

class DependancyContainer: ObservableObject {
    let signalColor: Color
    
    init() {
        self.signalColor = {
            if CommandLine.arguments.contains("-UITests") {
                return Color.blue
            } else {
                return Color.red
            }
        }()
    }
}

@main
struct GymMealPrepApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(DependancyContainer())
        }
        
    }
}
