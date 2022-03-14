//
//  UIDeviceManager.swift
//  
//
//  Created by Rifat Firdaus on 9/7/16.
//  Copyright © 2016 Suitmedia. All rights reserved.
//

import UIKit

class UIDeviceManager: NSObject {
    
    static func isIpad() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        }
        return false
    }
    
    static func isIPhone() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return true
        }
        return false
    }
    
    static func restartApp() {
        let viewController = LaunchHandlerViewController.instantiate()
        guard
            let window = UIApplication.shared.keyWindow,
            let rootViewController = window.rootViewController
            else {
                return
        }
        
        viewController.view.frame = rootViewController.view.frame
        viewController.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = viewController
        })
    }
    
}
