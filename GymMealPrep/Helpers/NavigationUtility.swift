//
//  NavigationUtility.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/11/23.
//

import UIKit

struct NavigationUtility {
    static func popToRootView(animated: Bool) {
        //TODO: replace windows with UIWindowScene.window
        findNavController(vc: UIApplication.shared.windows.filter( { $0.isKeyWindow }).first?.rootViewController)?.popToRootViewController(animated: animated)
    }
    
    static func findNavController(vc: UIViewController?) -> UINavigationController? {
        // unwrap vc
        guard let vc else { return nil }
        // check if ui nav controller
        if let navigationController = vc as? UINavigationController {
            return navigationController
        }
        // recursion for children
        for childVC in vc.children {
            return findNavController(vc: childVC)
        }
        return nil
    }
    
}
