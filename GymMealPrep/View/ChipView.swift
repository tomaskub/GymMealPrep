//
//  ChipView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/2/23.
//

import SwiftUI

struct ChipView<Content: View>: View {
    
    @Binding var tags: [Tag]
    @State var tagSize: [Tag : CGSize] = [:]
    @State var selectedTag: Tag? = nil
    let avaliableWidth: CGFloat
    let alignment: HorizontalAlignment
    let content: (Tag) -> Content
    
    
    
    var body: some View {
        VStack(alignment: alignment) {
            ForEach(sortToRows(), id: \.self) { row in
                HStack {
                    ForEach(row) { tag in
                        HStack {
                            content(tag)
                            if tag == selectedTag {
                                Button {
                                    removeSelectedTag()
                                } label: {
                                    Image(systemName: "x.circle")
                                }
                            }
                                
                        }
                            .fixedSize()
                            .readSize { size in
                                tagSize[tag] = size
                            }
                            .onLongPressGesture {
                                withAnimation(.linear) {
                                    selectedTag = tag
                                }
                                
                                    
                            }
                    }
                }// END OF HSTACK
            }
            

                
            
        }// END OF VSTACK
    }// END OF BODY
    private func removeSelectedTag() {
        if let selectedTag {
            tags.removeAll(where: {$0.id == selectedTag.id})
        }
    }
    private func sortToRows() -> [[Tag]] {
        var rows: [[Tag]] = [[]]
        var currentRow = 0
        var remainingWidth = avaliableWidth
        
        for tag in tags {
            let tagSize: CGFloat = tagSize[tag, default: CGSize(width: avaliableWidth, height: 1)].width
            if remainingWidth - tagSize >= 0 {
                rows[currentRow].append(tag)
            } else {
                currentRow += 1
                rows.append([tag])
                remainingWidth = avaliableWidth
            }
            remainingWidth -= tagSize
        }
        return rows
    }
    
}

struct ChipView_Previews: PreviewProvider {
    static var previews: some View {
        ChipView(tags:
                .constant([Tag(text: "Rice"),
                                     Tag(text: "Chicken"),
                                     Tag(text: "Dinner"),
                                     Tag(text: "Lunch")]),
                                  avaliableWidth: 200, alignment: .leading) { tag in
            Text(tag.text)
                .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                .background(
                Capsule()
                    .foregroundColor(.blue))
        }
        
    }
}
