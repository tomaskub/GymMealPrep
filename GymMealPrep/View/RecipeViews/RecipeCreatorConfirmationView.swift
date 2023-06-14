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
        VStack(alignment: .center) {
            Grid(alignment: .leading) {
                    Text("Time")
                    .font(.title3)
                    
                GridRow {
                    Text("Cooking time:")
                        .border(.green)
                    TextField("enter cooking time", text: $viewModel.timeCookingInMinutes)
                        .numericalInputOnly($viewModel.timeCookingInMinutes)
                        .border(.green)
                }
                GridRow {
                    Text("Preparing time:")
                        .border(.green)
                    TextField("Preparing time", text: $viewModel.timePreparingInMinutes)
                        .numericalInputOnly($viewModel.timePreparingInMinutes)
                        .border(.green)
                }
                GridRow {
                    Text("Time waiting:")
                        .border(.green)
                    TextField("Waiting time", text: $viewModel.timeWaitingInMinutes)
                        .numericalInputOnly($viewModel.timeWaitingInMinutes)
                        .border(.green)
                }
            }
            
            Divider()
            
            Stepper("Servings:  \(viewModel.servings)", value: $viewModel.servings)
                .fixedSize()
                .border(.red)
            
            Divider()
            
            HStack {
                Text("Tags")
                    .font(.title3)
                Spacer()
            }
                .border(.black)
            ChipView(tags: $viewModel.tags, avaliableWidth: UIScreen.main.bounds.width - 50, alignment: .center) { tag in
                Text(tag.text)
                    .foregroundColor(.white)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Capsule().foregroundColor(.blue))
            }
            
            .border(.blue)
            TextField("Add new tag", text: $viewModel.tagText)
                .onSubmit {
                    viewModel.addTag()
                }
                .border(.red)
            Button("Add photo") {
                print("Adding photo")
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding(.horizontal)
            .navigationTitle("Add details")
            .navigationBarTitleDisplayMode(.inline)
    }
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
