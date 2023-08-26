//
//  SettingsTabView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 26/08/2023.
//

import SwiftUI

struct SettingsTabView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var path = NavigationPath()
    var body: some View {
        NavigationStack {
                SettingsListView(viewModel: viewModel, path: $path)
        } // END OF NAV-STACK
    } // END OF BODY
} // END OF STRUCT

struct SettingsTabView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsTabView()
    }
}
