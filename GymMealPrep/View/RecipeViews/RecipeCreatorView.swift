//
//  RecipeCreatorView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/27/23.
//

import SwiftUI

struct RecipeCreatorView: View {
    
    @State private var ingredients = String()
    @State private var instructions = String()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Ingredients:")
                .fontWeight(.semibold)
                .font(.title3)
            
            TextEditor(text: $ingredients)
                .scrollContentBackground(.hidden)
                .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                .background(.gray.opacity(0.1))
                .cornerRadius(20)
            
            Text("Instructions:")
                .fontWeight(.semibold)
                .font(.title3)
            
            TextEditor(text: $instructions)
                .scrollContentBackground(.hidden)
                .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                .background(.gray.opacity(0.1))
                .cornerRadius(20)
            
            HStack {
                Spacer()
                Button {
                    print("Create button pressed")
                    print(ingredients)
                    print(instructions)
                } label: {
                    Text("Creating recipe")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .navigationTitle("Create recipe from text")
        
    }
}

struct RecipeCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeCreatorView()
        }
    }
}
