//
//  RecipeCreatorWebLinkView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 8/9/23.
//

import SwiftUI

struct RecipeCreatorWebLinkView: View {
    
    @ObservedObject var viewModel: RecipeCreatorViewModelProtocol
    let navTitle: String = "Import recipe"
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                TextField("Import from link", text: $viewModel.recipeLink)
                    .accessibilityIdentifier("recipe-link-text-field")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(20)
            }
            .padding()
        }
            .navigationTitle(navTitle)
    }
}

struct RecipeCreatorWebLinkView_Previews: PreviewProvider {
    struct PreviewContainer: View {
        @StateObject private var container: Container = .init()
        var body: some View {
            NavigationView {
                RecipeCreatorWebLinkView(viewModel: RecipeCreatorViewModel(dataManager: container.dataManager, networkController: container.networkController))
                    .environmentObject(container)
            }
        }
    }
    static var previews: some View {
        PreviewContainer()
    }
}
