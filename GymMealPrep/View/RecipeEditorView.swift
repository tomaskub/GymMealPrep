//
//  RecipeEditorView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/2/23.
//

import SwiftUI
import PhotosUI

struct RecipeEditorView: View {
    
    @ObservedObject var viewModel: RecipeViewModel
    @State var addNewIngredient: Bool = false
    
    var body: some View {
        List {
            
            informationSection
            
            tagSection
            
            nutritionSection
            
            timeSection
            
            ingredientSection
            
            instructionSection
            
        }//END OF LIST
        .sheet(item: $viewModel.selectedIngredient) { ingredientToEdit in
            IngredientEditorView(editedIngredient: ingredientToEdit) { ingredientToSave in
                viewModel.addIngredient(ingredientToSave)
            }
        }
        .sheet(isPresented: $addNewIngredient) {
            IngredientEditorView { ingredient in
                viewModel.addIngredient(ingredient)
            }
        }
    }//END OF BODY
    
    var instructionSection: some View {
        Section("Instructions") {
            ForEach($viewModel.recipe.instructions) { instruction in
                HStack{
                    Text("\(instruction.step.wrappedValue)")
                        .padding(.trailing)
                     
                    TextField("Instructions", text: instruction.text)
                    
                }
            }
            .onDelete { indexSet in
                viewModel.removeIngredient(at: indexSet)
            }
            .onMove { source, destination in
                viewModel.moveInstruction(from: source, to: destination)
            }
            
            HStack {
                Spacer()
                Image(systemName: "plus.circle")
                Spacer()
            }
            .onTapGesture {
                viewModel.addInstruction()
            }
        }//END OF SECTION
    }
    
    var ingredientSection: some View {
        Section("Ingredients") {
            ForEach(viewModel.recipe.ingredients) { ingredient in
                    HStack {
                        Text(ingredient.food.name)
                        Spacer()
                        Text(String(format: "%.2f",ingredient.quantity))
                        Text(ingredient.unitOfMeasure)
                    }
                    .onTapGesture {
                        viewModel.selectedIngredient = ingredient
                    }
            }
            .onDelete { indexSet in
                viewModel.removeIngredient(at: indexSet)
            }
            .onMove { from, to in
                viewModel.moveIngredient(from: from, to: to)
            }
            HStack {
                Spacer()
                Image(systemName: "plus.circle")
                Spacer()
            }
            .onTapGesture {
                addNewIngredient.toggle()
            }
        }//END OF SECTION
    }
    
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
                .overlay(alignment: .bottomTrailing) {
                    PhotosPicker(selection: $viewModel.selectedPhoto) {
                        Image(systemName: "pencil.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                            .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                    }
                    
                }
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
        Section("Nutrition") {
            RecipeSummaryView(cal: viewModel.recipe.nutritionData.calories,
                              proteinInGrams: viewModel.recipe.nutritionData.protein,
                              fatInGrams: viewModel.recipe.nutritionData.fat, carbInGrams: viewModel.recipe.nutritionData.carb, format: "%.0f")
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
