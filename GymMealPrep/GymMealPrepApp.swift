//
//  GymMealPrepApp.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//

import SwiftUI

@main
struct GymMealPrepApp: App {
    @StateObject private var container: Container = ContainerFactory.build()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(container)
        }
        
    }
}
