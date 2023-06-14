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
                    InstructionRowView(instructionText: instruction.text, step: instruction.step.wrappedValue, editable: true)
                } // END OF FOR EACH
                .onDelete { indexSet in
                    // remove instruction
                    viewModel.deleteInstruction(at: indexSet)
                }
                .onMove { source, destination in
                    // move instruction
                    viewModel.moveInstruction(fromOffset: source, toOffset: destination)
                }
                HStack {
                    Spacer()
                    Image(systemName: "plus.circle")
                    Spacer()
                }
                .onTapGesture {
                    // add new instruction
                    viewModel.addInstruction()
                }
            } // END OF LIST
            .scrollContentBackground(.hidden)
        } // END OF VSTACK
        .navigationTitle("Instructions")
        .navigationBarTitleDisplayMode(.inline)
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
        override func createRecipeViewModel() -> RecipeViewModel {
            var recipe = Recipe()
            recipe.instructions = parsedInstructions
            return RecipeViewModel(recipe: recipe, dataManager: DataManager.preview)
            
        }
        override func deleteInstruction(at offset: IndexSet) {
            parsedInstructions.remove(atOffsets: offset)
        }
        override func moveInstruction(fromOffset source: IndexSet, toOffset destination: Int) {
            parsedInstructions.move(fromOffsets: source, toOffset: destination)
        }
        override func addInstruction() {
            parsedInstructions.append(Instruction(step: parsedInstructions.count + 1))
        }
    }
    
    static var previews: some View {
        NavigationView {
            RecipeCreatorInstructionsView(viewModel: PreviewViewModel())
        }
    }
}
