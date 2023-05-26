//
//  TextFieldModifier.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/25/23.
//

import SwiftUI
import Combine

struct NumericalValueOnlyViewModifier: ViewModifier {
    
    @Binding var textInput: String
    var includeDecimal: Bool
    
    func body(content: Content) -> some View {
        content
            .keyboardType(includeDecimal ? .decimalPad : .numberPad)
            .onReceive(Just(textInput)) { newValue in
                //set up values to filter
                var numbers = "0123456789"
                let seperator: String = Locale.current.decimalSeparator ?? "."
                if includeDecimal {
                    numbers.append(seperator)
                }
                // check for double seperator and filter values
                if newValue.components(separatedBy: seperator).count > 2 {
                    let filtered = newValue
                    self.textInput = String(filtered.dropLast())
                } else {
                    let filtered = newValue.filter({ numbers.contains($0)})
                    if filtered != newValue {
                        self.textInput = filtered
                    }
                }
            }
    }
}

extension TextField {
    func numericalInputOnly(_ text: Binding<String>, includeDecimal: Bool = false) -> some View {
        self.modifier(NumericalValueOnlyViewModifier(textInput: text, includeDecimal: includeDecimal))
    }
}
