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
//                    titleBanner
                    Section {
                        titleBanner
                            .listRowInsets(EdgeInsets())
                        tagChipView
                            .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        HStack {
                            Spacer()
                            servingSummary
                            timeSummary
                            Spacer()
                        }
                        
                        nutritionSummary
                    }
                    .listRowSeparator(.hidden)

                    Section("Ingredients:") {
                        ForEach(viewModel.recipe.ingredients, id: \.food.name) {
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
                        ForEach(viewModel.recipe.instructions) { instruction in
                            HStack{
                                Text("\(instruction.step)")
                                    .padding(.trailing)
                                Text(instruction.text ?? "")
                            }
                        }
                    }
                }
                .listStyle(.inset)
                .ignoresSafeArea(edges: .top)
        }
    }
    
    var nutritionSummary: some View {
        VStack {
            Text("Nutrition value:")
                .font(.title2)
                .fontWeight(.semibold)
            HStack {
                ForEach(viewModel.nutritionalData, id: \.self) { data in
                Text(data)
                    .multilineTextAlignment(.center)
                    .frame(width: 80, height: 80)
                    .background()
                    .cornerRadius(10)
                }
            }
        }
    }
    
    
    var servingSummary: some View {
        VStack {
            Text("Servings:")
                .font(.title3)
                .fontWeight(.semibold)
            Text("\(viewModel.recipe.servings)")
        }
    }
    
    var timeSummary: some View {
        VStack {
            Text("Time:")
                .font(.title3)
                .fontWeight(.semibold)
            HStack {
                ForEach(viewModel.timeSummaryData, id: \.0) { data in
                    VStack {
                        Text(data.0)
                        Text(data.1)
                    }
                }
            }
        }
        .padding()
        .frame(maxHeight: .infinity)
        .background(.white)
        .cornerRadius(10)
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
            RecipeView(viewModel: RecipeViewModel(recipe: SampleData.recipieCilantroLimeChicken))
        }
    }
}
