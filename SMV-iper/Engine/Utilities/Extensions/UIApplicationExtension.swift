//
//  UIColorExtension.swift
//  bungkhus-ios-challenge-ui-profile-marchendise
//
//  Created by Bungkhus on 1/9/17.
//  Copyright © 2017 Bungkhus. All rights reserved.
//

import UIKit

extension UIApplication {
    
    static var flipAnimation: UIView.AnimationOptions = .transitionFlipFromRight
    static var fadeAnimation: UIView.AnimationOptions = .transitionCrossDissolve
    
    public static func setRootView(_ viewController: UIViewController,
                                   options: UIView.AnimationOptions = .transitionCrossDissolve,
                                   animated: Bool = true,
                                   duration: TimeInterval = 0.3,
                                   completion: (() -> Void)? = nil) {
        guard let windowOpt = UIApplication.shared.delegate?.window,
            let window = windowOpt
            else { return }
        
        guard animated else {
            window.rootViewController = viewController
            return
        }
        
        UIView.transition(with: window, duration: duration, options: options, animations: { [weak window] in
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            window?.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }) { _ in
            completion?()
        }
    }
    
}
