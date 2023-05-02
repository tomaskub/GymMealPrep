//
//  RecipeHostView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/1/23.
//

import SwiftUI

struct RecipeHostView: View {
    
    
    @Environment(\.editMode) var editMode
    @State var isEditing: Bool = false
    
    var body: some View {
        ZStack {
            
            if isEditing != true {
                                RecipieView(viewModel: RecipieViewModel(recipie: SampleData.recipieCilantroLimeChicken))
                
                
            } else {
                RecipeEditorView(viewModel: RecipieViewModel(recipie: SampleData.recipieCilantroLimeChicken))
            }
            //TODO: figure out why alignment on stacks dont work properly
            HStack {
                Spacer()
                VStack {
                    Button {
                        isEditing.toggle()
                    } label: {
                        Image(systemName: "pencil")
                            .font(.title3)
                            .foregroundColor(.white)
                            .background(
                                Circle()
                                    .foregroundColor(.gray.opacity(0.8))
                                    .frame(width: 30, height: 30))
                    }
                    Spacer()
                }
            }.padding()
        }
    }
}

struct RecipeHostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeHostView()
        }
    }
}
