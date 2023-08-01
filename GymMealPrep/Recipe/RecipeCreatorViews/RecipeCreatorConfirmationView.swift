//
//  RecipeCreatorConfirmationView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/14/23.
//

import SwiftUI
import PhotosUI

struct RecipeCreatorConfirmationView: View {
    @ObservedObject var viewModel: RecipeCreatorViewModelProtocol
    
    var body: some View {
        
        List {
            
            Section("Photo") {
                    if let image = viewModel.recipeImage {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .listRowInsets(EdgeInsets())
                    } // END OF IMAGE
                    HStack {
                        Spacer()
                        PhotosPicker(selection: $viewModel.selectedImage){
                            Text(viewModel.recipeImage == nil ? "Add photo" : "Change photo")
                                .accessibilityIdentifier("add-change-photo")
                        } // END OF PHOTOSPICKER
                        .buttonStyle(.borderedProminent)
                        if viewModel.recipeImage != nil {
                            Button(role: .destructive) {
                                viewModel.deletePhoto()
                            } label: {
                                Text("Delete")
                            } // END OF BUTTON
                            .accessibilityIdentifier("delete-photo")
                            .buttonStyle(.borderedProminent)
                        } // END OF IF
                        Spacer()
                    } // END OF HSTACK
                } // END OF SECTION
            
            
            Section("Time cooking") {
                Grid(alignment: .leading) {
                    
                    GridRow {
                        Text("Cooking time:")
                        
                        TextField("minutes", text: $viewModel.timeCookingInMinutes)
                            .numericalInputOnly($viewModel.timeCookingInMinutes)
                            .accessibilityIdentifier("cooking-time-text-field")
                            .textFieldStyle(.roundedBorder)
                    } // END OF GRID ROW
                    
                    GridRow {
                        Text("Preparing time:")
                        
                        TextField("minutes", text: $viewModel.timePreparingInMinutes)
                            .numericalInputOnly($viewModel.timePreparingInMinutes)
                            .accessibilityIdentifier("preparing-time-text-field")
                            .textFieldStyle(.roundedBorder)
                    } // END OF GRID ROW
                    
                    GridRow {
                        Text("Time waiting:")
                        
                        TextField("minutes", text: $viewModel.timeWaitingInMinutes)
                            .numericalInputOnly($viewModel.timeWaitingInMinutes)
                            .accessibilityIdentifier("waiting-time-text-field")
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
        
        override var selectedImage: PhotosPickerItem? {
            didSet {
                if let selectedImage {
                    Task { @MainActor in
                        do {
                            recipeImage = try await selectedImage.loadTransferable(type: Image.self) ?? Image(systemName: "photo")
                        } catch {
                            print("Error loading photo: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
        
        override func deletePhoto() {
            recipeImage = nil
        }
        
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
