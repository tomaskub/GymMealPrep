//
//  KeyboardReadable.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 7/13/23.
//

import Combine
import UIKit

protocol KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> { get }
}

extension KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
                .map({ _ in
                    true
                }),
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
                .map({ _ in
                    false
                })
        )
        .eraseToAnyPublisher()
    }
                                            
}
