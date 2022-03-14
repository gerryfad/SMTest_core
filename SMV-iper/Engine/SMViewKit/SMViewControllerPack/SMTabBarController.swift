//
//  SMTabBarController.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 18/12/18.
//  Copyright © 2018 Rifat Firdaus. All rights reserved.
//

import UIKit

class SMTabBarController: UITabBarController {
    
    var tabBarList = [UIViewController]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        initialize()
    }
    
    func initialize() {
        self.tabBar.barTintColor = SMUITheme.tabBar.barTintColor
        self.tabBar.tintColor = SMUITheme.tabBar.tintColor
        self.tabBar.unselectedItemTintColor = SMUITheme.tabBar.unselectedItemTintColor
        self.extendedLayoutIncludesOpaqueBars = true
        viewControllers = tabBarList
        
        
    }

}

extension SMTabBarController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        item.badgeValue = nil
    }
    
}
