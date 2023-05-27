//
//  RecipeCreatorView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/27/23.
//

import SwiftUI

struct RecipeCreatorView: View {
    
    @StateObject private var viewModel = RecipeCreatorViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Ingredients:")
                .fontWeight(.semibold)
                .font(.title3)
            
            TextEditor(text: $viewModel.ingredientsEntry)
                .scrollContentBackground(.hidden)
                .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                .background(.gray.opacity(0.1))
                .cornerRadius(20)
            
            Text("Instructions:")
                .fontWeight(.semibold)
                .font(.title3)
            
            TextEditor(text: $viewModel.instructionsEntry)
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
                    Text("Create recipe")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .background(.blue)
                        .cornerRadius(8)
                } // END OF NAV LINK
            } // END OF HSTACK
        } // END OF VSTACK
        .padding()
        .navigationTitle("Create recipe from text")
    } // END OF BODY
} // END OF STRUCT

struct RecipeCreatorParserView: View {
    
    @ObservedObject var viewModel: RecipeCreatorViewModel
    
    var body: some View {
        VStack {
            
            Text("Ingredients:")
                .font(.title)
            
            ForEach(viewModel.parsed, id: \.self.text) { response in
                Text(response.parsed?.first?.food.label ?? "Unknown")
            }
        }
        .onAppear {
            print("Processing input at on appear call")
            viewModel.processInput()
        }
    }
}
struct RecipeCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeCreatorView()
        }
    }
}
