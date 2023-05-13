//
//  RecipeSummaryView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/13/23.
//

import SwiftUI

struct RecipeSummaryView: View {
    let servings: Int
    let summaryData: [(String, String)]
    let nutritionalData: [String]
    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                VStack {
                    Text("Servings:")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("\(servings)")
                }
                VStack {
                    Text("Time:")
                        .font(.title3)
                        .fontWeight(.semibold)
                    HStack {
                        ForEach(summaryData, id: \.0) { data in
                            VStack {
                                Text(data.0)
                                Text(data.1)
                            }
                        }
                    }
                }
                .padding()
//                .frame(maxHeight: .infinity)
                .background(.white)
                .cornerRadius(10)
                Spacer()
            }
            VStack {
                Text("Nutrition value:")
                    .font(.title2)
                    .fontWeight(.semibold)
                HStack {
                    ForEach(nutritionalData, id: \.self) { data in
                        Text(data)
                            .multilineTextAlignment(.center)
                            .frame(width: 80, height: 80)
                            .background()
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}

struct RecipeSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray
            
            RecipeSummaryView(servings: 1, summaryData: [
                ("Prep", "\(10)"),
                ("Cook", "\(20)"),
                ("Wait", "\(30)"),
                ("Total", "\(60)")],
                              nutritionalData: [
                                String(format: "%.0f", Float(490)) + "\n Cal",
                                String(format: "%.0f", Float(46)) + "g\n Protein",
                                String(format: "%.0f", Float(20)) + "g\n Fat",
                                String(format: "%.0f", Float(35)) + "g\n Carb",
                              ]
            )
        }
    }
}
