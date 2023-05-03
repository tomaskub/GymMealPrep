//
//  ChipViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/3/23.
//

import Foundation
import UIKit
import Combine

class ChipViewModel: ObservableObject {
    //MARK: PUBLISHED VALUES
    @Published var tags: [Tag]
    @Published var tagsSize: [Tag : CGSize] = [:]

    let avaliableWidth: CGFloat
    
    var rows: [[Tag]] {
        sortToRows()
    }
    
    init(tags: [Tag], avaliableWidth: CGFloat) {
        self.tags = tags
        self.avaliableWidth = avaliableWidth
    }
    
    private func sortToRows() -> [[Tag]] {
        var rows: [[Tag]] = [[]]
        var currentRow = 0
        var remainingWidth = avaliableWidth
        
        for tag in tags {
            let tagSize: CGFloat = tagsSize[tag, default: CGSize(width: avaliableWidth, height: 1)].width
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
    
    func getSize(text: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 14)
        let attributes = [NSAttributedString.Key.font: font]
        let size = text.size(withAttributes: attributes)
        return size.width
    }
}
