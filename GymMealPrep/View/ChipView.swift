//
//  ChipView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/2/23.
//

import SwiftUI

struct ChipView<Content: View>: View {
    
    @StateObject var viewModel: ChipViewModel
    let content: (Tag) -> Content
    
    var body: some View {
        VStack {
            ForEach(viewModel.rows, id: \.self) { row in
                HStack {
                    ForEach(row) { tag in
                        content(tag)
                            .fixedSize()
                            .readSize { size in
                                viewModel.tagsSize[tag] = size
                            }
                    }
                }// END OF HSTACK
            }
        }// END OF VSTACK
    }// END OF BODY
}

struct ChipView_Previews: PreviewProvider {
    static var previews: some View {
        ChipView(viewModel:
                    ChipViewModel(tags:
                                    [Tag(text: "Rice"),
                                     Tag(text: "Chicken"),
                                     Tag(text: "Dinner"),
                                     Tag(text: "Lunch")],
                                  avaliableWidth: 200)) { tag in
            Text(tag.text)
                .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                .background(
                Capsule()
                    .foregroundColor(.blue))
        }
        
    }
}
