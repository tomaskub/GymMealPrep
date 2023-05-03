//
//  RecipeEditorView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/2/23.
//

import SwiftUI

struct RecipeEditorView: View {
    
    @ObservedObject var viewModel: RecipeViewModel
    
    @State var prepTime: String = String()
    @State var cookTime: String = String()
    @State var waitTime: String = String()
    
    var body: some View {
        List {
            
            informationSection
            
            tagSection
            
            nutritionSection
            
            timeSection
            
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
    
    var timeSection: some View {
        Section("Cooking time") {
            
            HStack {
                Text("Time total:")
                Spacer()
                Text("\(viewModel.totalTimeCookingInMinutes) min")
            }
               
            HStack {
                Text("Prep:")
                Spacer()
                TextField("0 minutes", text: $viewModel.timePreparingInMinutes)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100)
                    .keyboardType(.numbersAndPunctuation)
            }
            
            HStack {
                Text("Cook:")
                Spacer()
                TextField("0 minutes", text: $viewModel.timeCookingInMinutes)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100)
                    .keyboardType(.numbersAndPunctuation)
            }
            .listRowSeparator(.hidden)
            HStack {
                Text("Wait:")
                Spacer()
                TextField("0 minutes", text: $viewModel.timeWaitingInMinutes)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100)
                    .keyboardType(.numbersAndPunctuation)
            }
            .listRowSeparator(.hidden)
        } // END OF SECTION
    }
    
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
            TextField("Add new tag", text: $viewModel.tagText)
                .onSubmit {
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
            Stepper("Servings: \(viewModel.recipe.servings)", value: $viewModel.recipe.servings)
                .font(.title3)
                .padding()
        }
    }
    
}

struct RecipeEditorView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeEditorView(viewModel: RecipeViewModel(recipe: SampleData.recipieCilantroLimeChicken))
    }
}
