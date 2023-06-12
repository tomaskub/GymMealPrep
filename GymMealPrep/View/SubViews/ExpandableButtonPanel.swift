//
//  ExpandableButtonPanel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/10/23.
//

import SwiftUI
//TODO: Animations and transitions do not work as expected
struct ExpandableButtonPanel: View {
    
    @State private var isExpanded: Bool = false
    
    let nonExpandable: ExpandableButtonPanelItem
    let expandable: [ExpandableButtonPanelItem]
    
    var body: some View {
        
            HStack {
                
                Image(systemName: "chevron.left")
                    .rotationEffect(Angle(degrees: isExpanded ? 180 : 0))
                    .onTapGesture {
                            isExpanded.toggle()
                    }
                    .animation(.easeInOut(duration: 0.5), value: isExpanded)
                
                if isExpanded {
                    ForEach(expandable) { item in
                        if let systemName = item.systemName {
                            Image(systemName: systemName)
                                .onTapGesture {
                                    if let action = item.action {
                                        action()
                                    }
                                }
                        } else {
                            Text(item.label)
                                .onTapGesture {
                                    if let action = item.action {
                                        action()
                                    }
                                }
                        }
                    }
                }
                if let sysName = nonExpandable.systemName {
                    Image(systemName: sysName)
                        .onTapGesture {
                            if let action = nonExpandable.action {
                                action()
                            }
                        }
                } else {
                    Text(nonExpandable.label)
                        .onTapGesture {
                            if let action = nonExpandable.action {
                                action()
                            }
                        }
                }
            }
    }
    

}

struct ExpandableButtonPanelItem: Identifiable {
    let id = UUID()
    let label: String
    let systemName: String?
    private(set) var action: (()-> Void)?
    
    init(label: String, systemName: String? = nil, action: ( () -> Void)? = nil){
        self.label = label
        self.systemName = systemName
        self.action = action
    }
}

struct ExpandableButtonPanel_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Text("This is a sample view")
                .navigationTitle("Navigation title")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        ExpandableButtonPanel(
                            nonExpandable: ExpandableButtonPanelItem(
                                label: "Sample",
                                systemName: "plus.circle",
                                action: {}),
                            expandable: [
                            ExpandableButtonPanelItem(label: "expanded"),
                            ExpandableButtonPanelItem(label: "expanded2")])
                    }
                }
        }
    }
}
