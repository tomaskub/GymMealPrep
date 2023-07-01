//
//  InstructionRowView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/7/23.
//

import SwiftUI

struct InstructionRowView: View {
    
    @Binding var instructionText: String
    let step: Int
    let editable: Bool
    
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            
            Text("\(step)")
                .fontWeight(.semibold)
                .padding(.top, 8)
            
            // use text to size the text editor through zstack
            ZStack {
                Text(instructionText)
                    .opacity(editable ? 0 : 1)
                
                if editable {
                    TextEditor(text: $instructionText)
                }
            }
        }
    }
}

struct InstructionRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ForEach(1..<5) { step in
                InstructionRowView(instructionText: .constant("This is a very long text that has multiple lines and therefore has to make sure that it is in the length that forces the view height key to trigger the redraw"), step: step, editable: step.isMultiple(of: 2))
            }
        }
    }
}
