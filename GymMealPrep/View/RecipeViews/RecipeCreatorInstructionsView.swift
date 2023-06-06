//
//  RecipeCreatorInstructionsView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/6/23.
//

import SwiftUI

struct RecipeCreatorInstructionsView: View {
    
    @ObservedObject var viewModel: RecipeCreatorViewModelProtocol
    
    var body: some View {
        VStack {
            List {
                ForEach($viewModel.parsedInstructions) { instruction in
                    // TODO: MOVE THE HSTACK TO ITS OWN COMPONENT VIEW 
                    HStack(alignment: .top) {
                        
                        Text("\(instruction.step.wrappedValue)")
                            .font(.body)
                            .fontWeight(.semibold)
                            .padding(.top, 8)
                        
                        TextEditor(text: instruction.text)
                    } // END OF HSTACK
                } // END OF FOR EACH
                .onDelete { indexSet in
                    // remove instruction
                }
                .onMove { source, destination in
                    // move instruction
                }
                HStack {
                    Spacer()
                    Image(systemName: "plus.circle")
                    Spacer()
                }
                .onTapGesture {
                    // add new instruction
                }
            } // END OF LIST
            .scrollContentBackground(.hidden)
            NavigationLink {
                Text("Instruction parser")
            } label: {
                Text("Confirm instructions")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    .background(.blue)
                    .cornerRadius(8)
            }
        } // END OF VSTACK
        .navigationTitle("Instructions")
    }
}


struct RecipeCreatorInstructionsView_Previews: PreviewProvider {
    
    class PreviewViewModel: RecipeCreatorViewModelProtocol {
        
        override init() {
            super.init()
            self.parsedInstructions = [
                Instruction(step: 1, text: "Instruction step 1. this is a long instruction step so it has multiple lines and it is concerning that it does not work straingt out of the box"),
                Instruction(step: 2, text: "Instruction step 2"),
                Instruction(step: 3, text: "Instruction step 3"),
                Instruction(step: 4, text: "Instruction step 4")
            ]
        } // END OF INIT
        
        override func processInput() {
            print("Processing input called")
        }
    }
    
    static var previews: some View {
        NavigationView {
            RecipeCreatorInstructionsView(viewModel: PreviewViewModel())
        }
    }
}
