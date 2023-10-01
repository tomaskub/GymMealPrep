//
//  SettingsDetailView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 30/09/2023.
//

import SwiftUI

struct SettingsDetailView: View {
    @State private var boolExample: Bool = false
    @State private var stringExample: String = .init()
    var body: some View {
        List {
            Section {
                Toggle("Sample setting", isOn: $boolExample)
                makeTooltip(text: "This is an description of the settings and a short instructions about how you should use it. The way it is constructed should be automatic depending on the data the view gets when it gets initiated. Additionaly it has to have a way to change the setting on dismiss or just in general")
                    
            } header: {
                Text("This is a bool setting example")
            }
            
            Section {
                HStack {
                    Text("Name of setting")
                    Spacer()
                    TextField("calories", text: $stringExample)
                        .frame(width: 100)
                        .textFieldStyle(.roundedBorder)
                }
                makeTooltip(text: "Short tooltip of the setting - this setting is something you add in with the keyboard")
            } header: {
                Text("This is a text input example")
            }
            
            Section {
                Text("picker thing?")
                
            } header: {
                Text("Picker wheel example")
            }
            
        }
        .navigationTitle("This is detail titile for the setting")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func makeTooltip(text: String) -> some View {
        Text(text)
            .font(.caption)
            .foregroundColor(.gray)
    }
}

struct SettingsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsDetailView()
        }
    }
}
