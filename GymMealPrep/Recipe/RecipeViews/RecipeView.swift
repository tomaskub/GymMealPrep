//
//  RecipieView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//

import SwiftUI

struct RecipeView: View {
    
    @StateObject var viewModel: RecipeViewModel
    
    var body: some View {
        ZStack {
            //Background layer
            Color.gray
                .ignoresSafeArea()
            
            //Content layer
                List {

                    Section {
                        titleBanner
                            .listRowInsets(EdgeInsets())
                        tagChipView
                            .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        HStack {
                            Spacer()
                            RecipeSummaryView(timePreparingInMinutes: viewModel.recipe.timePreparingInMinutes ?? 0,
                                              timeCookingInMinutes: viewModel.recipe.timeCookingInMinutes ?? 0,
                                              timeWaitingInMinues: viewModel.recipe.timeWaitingInMinutes ?? 0,
                                              timeTotalInMinutes: viewModel.totalTimeCookingInMinutes,
                                              cal: viewModel.recipe.nutritionData.calories,
                                              proteinInGrams: viewModel.recipe.nutritionData.protein,
                                              fatInGrams: viewModel.recipe.nutritionData.fat,
                                              carbInGrams: viewModel.recipe.nutritionData.carb,
                                              servings: viewModel.recipe.servings,
                                              format: "%.0f")
                            Spacer()
                        }
                    }
                    .listRowSeparator(.hidden)
                    
                    
                    Section("Ingredients:") {
                        ForEach(viewModel.recipe.ingredients) {
                            i in
                            HStack {
                                Text(i.food.name)
                                Spacer()
                                Text(String(format: "%.2f",i.quantity))
                                Text(i.unitOfMeasure)
                            }
                            
                        }
                    }
                    Section("Instructions") {
                        ForEach($viewModel.recipe.instructions) { instruction in
                            InstructionRowView(instructionText: instruction.text, step: instruction.step.wrappedValue, editable: false)
                        }
                    }
                }
                .listStyle(.inset)
                .ignoresSafeArea(edges: .top)
        }
    }
    
    var titleBanner: some View {
        viewModel.image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity)
            .frame(height: 250)
            .clipped()
            .overlay {
                ZStack(alignment: .bottomLeading) {
                    
                    LinearGradient(colors: [.black, .black.opacity(0.0)], startPoint: .bottom, endPoint: .center)
                    HStack {
                        Text(viewModel.recipe.name)
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
    }
    
    var tagChipView: some View {
        
        
        ChipView(tags: $viewModel.recipe.tags, avaliableWidth: UIScreen.main.bounds.width - 20, alignment: .leading) { tag in
                    Text(tag.text)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                        .background(
                            Capsule()
                            .foregroundColor(.blue))
                }
         
    }
}

struct RecipieView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeView(viewModel: RecipeViewModel(recipe: SampleData.recipieCilantroLimeChicken, dataManager: DataManager.preview))
        }
    }
}
