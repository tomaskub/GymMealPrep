//
//  ExpandableButtonPanel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/10/23.
//

import SwiftUI

struct ExpandableButtonPanel: View {
    
    let primaryButton: ExpandableButtonItem
    let secondaryButtons: [ExpandableButtonItem]
    
    private let size: CGFloat = 70
    @State private var isExpanded: Bool = false
    
    var body: some View {
        HStack {
            Button("<") {
                withAnimation {
                    self.isExpanded.toggle()
                }
            }
            ForEach(secondaryButtons) { button in
                Text(button.label)
                    .onTapGesture {
                        if let action = button.action {
                            action()
                        }
                    }
                    .frame(
                        width: self.isExpanded ? self.size : 0,
                        height: self.isExpanded ? self.size : 0
                    )
            }
            Button(primaryButton.label) {
                if let action = primaryButton.action {
                    action()
                }
            }
        }
    }
}

struct ExpandableButtonItem: Identifiable {
    let id = UUID()
    let label: String
    private(set) var action: (()-> Void)? = nil
}

struct ExpandableButtonPanel_Previews: PreviewProvider {
    static var previews: some View {
        ExpandableButtonPanel(
            primaryButton: ExpandableButtonItem(label: "P"),
            secondaryButtons: [
                ExpandableButtonItem(label: "S"),
            ExpandableButtonItem(label: "T")
            ]
        )
    }
}
