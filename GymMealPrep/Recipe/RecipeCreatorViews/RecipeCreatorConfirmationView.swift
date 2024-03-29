//
//  RecipeCreatorConfirmationView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/14/23.
//

import SwiftUI
import PhotosUI
import UIKit

struct RecipeCreatorConfirmationView: View {
    @ObservedObject var viewModel: RecipeCreatorViewModelProtocol
    @State private var image: Image?
    @State private var pickerSelection: PhotosPickerItem?
    
    var body: some View {
        
        List {
            
            photoSection
            
            timeCookingSection
            
            tagsSection
            
        } // END OF LIST
        .navigationTitle("Add details")
        .navigationBarTitleDisplayMode(.inline)
    } // END OF BODY
    //MARK: UI VAR DECLARATION
    var photoSection: some View {
        Section("Photo") {
                if let _image = image {
                    _image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .listRowInsets(EdgeInsets())
                } // END OF IMAGE
                HStack {
                    Spacer()
                    PhotosPicker(selection: $pickerSelection, matching: .images){
                        Text(image == nil ? "Add photo" : "Change photo")
                            .accessibilityIdentifier("add-change-photo")
                    } // END OF PHOTOSPICKER
                    .task(id: pickerSelection) {
                        image = await loadPhoto(from: pickerSelection)
                    }
                    .buttonStyle(.borderedProminent)
                    if image != nil {
                        Button(role: .destructive) {
                            viewModel.deleteImageData()
                            self.image = nil
                        } label: {
                            Text("Delete")
                        } // END OF BUTTON
                        .accessibilityIdentifier("delete-photo")
                        .buttonStyle(.borderedProminent)
                    } // END OF IF
                    Spacer()
                } // END OF HSTACK
            } // END OF SECTION
    }
    
    var timeCookingSection: some View {
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
    }
    
    var tagsSection: some View {
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
                .disabled(viewModel.tagText.isEmpty)
                .buttonStyle(.borderedProminent)
            } // END OF HSTACK
        } // END OF SECTION
    }
}

//MARK: LOAD PHOTO
extension RecipeCreatorConfirmationView {
    func loadPhoto(from imageSelection: PhotosPickerItem?) async -> Image? {
        do {
            if let data = try await imageSelection?.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    viewModel.addImageData(data: data)
                    return Image(uiImage: uiImage)
                }
            }
            return nil
        } catch {
            print("Error loading photo: \(error.localizedDescription)")
            return nil
        }
    }
    
}

struct RecipeCreatorConfirmationView_Previews: PreviewProvider {
    
    class PreviewViewModel: RecipeCreatorViewModelProtocol {
        
        override func deleteImageData() {
            
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
    }
    
    static var previews: some View {
        NavigationStack {
            RecipeCreatorConfirmationView(viewModel: PreviewViewModel())
        }
    }
}
