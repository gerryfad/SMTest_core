//
//  LaunchHandlerViewController.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 19/12/18.
//  Copyright © 2018 Rifat Firdaus. All rights reserved.
//

import UIKit

class LaunchHandlerViewController: UIViewController {

    static func instantiate() -> UIViewController {
        let controller = UIStoryboard.main.instantiateViewController(withIdentifier: self.className())
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("🇮🇩 \(PreferenceManager.instance.language)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        launchMainTabbar()
    }
    
    func launchMainTabbar() {
        UIApplication.setRootView(MainTabBarController.instantiate())
    }

}
