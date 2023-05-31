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
            IngredientEditorView(
                viewModel: IngredientEditorViewModel(ingredientToEdit: ingredientToEdit)) { ingredientToSave in
                viewModel.addIngredient(ingredientToSave)
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
            
            NavigationLink {
                IngredientHostView(title: "Add new ingredient", buttonTitle: "Add manually", saveHandler: viewModel, pickerViewModel: IngredientPickerViewModel())
            } label: {
                HStack {
                    Spacer()
                    Text("Add new ingredient")
                    Spacer()
                }
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
            .listRowSeparator(.visible)
               
            HStack {
                Text("Prep:")
                Spacer()
                TextField("0 minutes", text: $viewModel.timePreparingInMinutes)
                    .numericalInputOnly($viewModel.timePreparingInMinutes)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100)
            }
            
            HStack {
                Text("Cook:")
                Spacer()
                TextField("0 minutes", text: $viewModel.timeCookingInMinutes)
                    .numericalInputOnly($viewModel.timeCookingInMinutes)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100)
            }
            
            HStack {
                Text("Wait:")
                Spacer()
                TextField("0 minutes", text: $viewModel.timeWaitingInMinutes)
                    .numericalInputOnly($viewModel.timeWaitingInMinutes)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100)
                    
            }
            
        } // END OF SECTION
        .listRowSeparator(.hidden)
        .onSubmit {
            viewModel.updateTimeData()
        }
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
        NavigationView {
            RecipeEditorView(viewModel: RecipeViewModel(recipe: SampleData.recipieCilantroLimeChicken))
        }
    }
}
