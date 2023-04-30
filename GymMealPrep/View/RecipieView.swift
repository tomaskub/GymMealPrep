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
//                    titleBanner
                    Section {
                        titleBanner
                            .listRowInsets(EdgeInsets())
                        tagScrollView
                            .listRowInsets(EdgeInsets())
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
            Text("\(viewModel.recipie.servings)")
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
                        Text(viewModel.recipie.name)
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: "pencil.circle")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding(.trailing)
                    }
                }
            }
    }
    var tagScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.recipie.tags) { tag in
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
    }
}

struct RecipieView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipieView(viewModel: RecipieViewModel(recipie: Recipie()))
        }
    }
}
