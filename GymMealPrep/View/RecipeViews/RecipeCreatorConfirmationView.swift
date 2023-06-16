//
//  RecipeCreatorConfirmationView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/14/23.
//

import SwiftUI

struct RecipeCreatorConfirmationView: View {
    @ObservedObject var viewModel: RecipeCreatorViewModelProtocol
    
    var body: some View {
        
        List {
            
            Section("Photo") {
                Button {
                    print("Adding photo")
                } label: {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal, 50)
                }
                
            }
            
            Section("Time cooking") {
                Grid(alignment: .leading) {
                    
                    GridRow {
                        Text("Cooking time:")
                        
                        TextField("minutes", text: $viewModel.timeCookingInMinutes)
                            .numericalInputOnly($viewModel.timeCookingInMinutes)
                            .textFieldStyle(.roundedBorder)
                    } // END OF GRID ROW
                    
                    GridRow {
                        Text("Preparing time:")
                        
                        TextField("minutes", text: $viewModel.timePreparingInMinutes)
                            .numericalInputOnly($viewModel.timePreparingInMinutes)
                            .textFieldStyle(.roundedBorder)
                    } // END OF GRID ROW
                    
                    GridRow {
                        Text("Time waiting:")
                        
                        TextField("minutes", text: $viewModel.timeWaitingInMinutes)
                            .numericalInputOnly($viewModel.timeWaitingInMinutes)
                            .textFieldStyle(.roundedBorder)
                        
                    } // END OF GRID ROW
                } // END OF GRID
            } // END OF SECTION
            
            
            Section("Tags") {
                
                ChipView(tags: $viewModel.tags, avaliableWidth: UIScreen.main.bounds.width - 50, alignment: .center) { tag in
                    Text(tag.text)
                        .foregroundColor(.white)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(Capsule().foregroundColor(.blue))
                } // END OF CHIPVIEW
                
                HStack {
                    
                    TextField("Add new tag", text: $viewModel.tagText)
                        .onSubmit {
                            viewModel.addTag()
                        }
                    
                    Button("Add") {
                        viewModel.addTag()
                    }
                    .buttonStyle(.borderedProminent)
                    
                } // END OF HSTACK
            } // END OF SECTION
            
        } // END OF LIST
        .navigationTitle("Add details")
        .navigationBarTitleDisplayMode(.inline)
    } // END OF BODY
}

struct RecipeCreatorConfirmationView_Previews: PreviewProvider {
    
    class PreviewViewModel: RecipeCreatorViewModelProtocol {
        override init() {
            super.init()
            self.tags = [
                Tag(text: "Tag 1"), Tag(text: "Tag 2"), Tag(text: "Tag 3"), Tag(text: "Tag 3"), Tag(text: "Tag 3"), Tag(text: "Tag 3"), Tag(text: "Tag 3")
            ]
        }
        
        override func addTag() {
            tags.append(Tag(text: tagText))
            tagText = String()
        }
        
        override func processInput() {
            // do nothing
        }
        override func addIngredient(_: Ingredient, _: String?) {
            // do nothing
        }
        override func createRecipeViewModel() -> RecipeViewModel {
            return RecipeViewModel(recipe: Recipe())
        }
    }
    
    static var previews: some View {
        NavigationStack {
            RecipeCreatorConfirmationView(viewModel: PreviewViewModel())
        }
    }
}
