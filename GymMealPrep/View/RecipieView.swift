//
//  RecipieView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 4/29/23.
//

import SwiftUI

struct RecipieView: View {
    
    @StateObject var viewModel: RecipieViewModel
    
    var body: some View {
        ZStack {
            //Background layer
            Color.gray
                .ignoresSafeArea()
            
            //Content layer
                List {
                    titleBanner
                        .listRowInsets(EdgeInsets())
                    tagScrollView
                    HStack {
                        servingSummary
                        timeSummary
                    }
                    nutritionSummary
                    Section("Ingredients:") {
                        ForEach(viewModel.recipie.ingredients, id: \.food.name) {
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
                        ForEach(viewModel.recipie.instructions) { instruction in
                            HStack{
                                Text("\(instruction.step)")
                                    .padding(.trailing)
                                Text(instruction.text)
                            }
                        }
                    }
                }
                
                
                
            
            
            
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
            Text("\(viewModel.recipie.servings)")
        }
        .padding()
        .frame(maxHeight: .infinity)
        .background(.white)
        .cornerRadius(10)
    }
    
    var timeSummary: some View {
        VStack(alignment: .leading) {
            Text("Time:")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.leading)
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
                ZStack {
                    
                    LinearGradient(colors: [.black, .black.opacity(0.0)], startPoint: .bottom, endPoint: .center)
                    
                    Text(viewModel.recipie.name)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(.leading)
                        .offset(y: 105)
                    
                }
            }
//            .ignoresSafeArea()
    }
    var tagScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.recipie.tags) { tag in
                    Text(tag.text)
                        .padding(.horizontal)
                        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                        .background(
                            Capsule()
                            .foregroundColor(.white))
                }
            }
        }
    }
}

struct RecipieView_Previews: PreviewProvider {
    static var previews: some View {
        RecipieView(viewModel: RecipieViewModel(recipie: Recipie()))
    }
}
