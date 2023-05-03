//
//  RecipeEditorView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/2/23.
//

import SwiftUI

struct RecipeEditorView: View {
    
    @ObservedObject var viewModel: RecipeViewModel
    
    @State var recipieTitle: String = ""
    @State var servings: Int = Int()
    
    @State var prepTime: String = String()
    @State var cookTime: String = String()
    @State var waitTime: String = String()
    
    var body: some View {
        List {
            
            informationSection
            
            tagSection
            
            nutritionSection
            
            Section("Time data") {
                
                HStack {
                    Text("Time:")
                        .font(.title3)
                    Spacer()
                    Text("Total: \(0.0)")
                }
                HStack {
                    Text("Prep:")
                    Spacer()
                    TextField("0 minutes", text: $prepTime)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 100)
                        .keyboardType(.numbersAndPunctuation)
                }
                
                HStack {
                    Text("Cook:")
                    TextField("0 minutes", text: $cookTime)
                }
                HStack {
                    Text("Wait:")
                    TextField("0 minutes", text: $waitTime)
                }
            } // END OF SECTION
            
            Section("Ingredients") {
                HStack {
                    Spacer()
                    Image(systemName: "plus.circle")
                    Spacer()
                }
            }//END OF SECTION
            
            Section("Instructions") {
                HStack {
                    Spacer()
                    Image(systemName: "plus.circle")
                    Spacer()
                }
            }//END OF SECTION
            
        }//END OF LIST
    }//END OF BODY
    
    var informationSection: some View {
        Section("Recipe information") {
            viewModel.image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 250)
                .listRowInsets(EdgeInsets())
            TextField("Enter recipie name", text: $viewModel.recipe.name)
        }
    }
    
    var tagSection: some View {
        Section("Tags") {
            TextField("Add new tag", text: $viewModel.tagText) {
                viewModel.addTag()
            }
            
            ChipView(tags: $viewModel.recipe.tags, avaliableWidth: UIScreen.main.bounds.width - 80, alignment: .leading) { tag in
                Text(tag.text)
                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                    .background(
                        Capsule()
                            .foregroundColor(.blue))
            }
        }// END OF SECTION
    }
    var nutritionSection: some View {
        Section("Nutrition value") {
            VStack(alignment: .leading) {
                Text("Per serving")
                    .font(.title3)
                    .padding(.bottom)
                HStack(spacing: 20) {
                    Spacer()
                    ForEach(viewModel.nutritionalData, id: \.self) { data in
                        Text(data)
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                }
                
            }
            Stepper("Servings: \(servings)", value: $servings)
        }
    }
    
}

struct RecipeEditorView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeEditorView(viewModel: RecipeViewModel(recipe: SampleData.recipieCilantroLimeChicken))
    }
}
