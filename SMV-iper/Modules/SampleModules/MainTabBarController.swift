//
//  MainTabBarController.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 19/12/18.
//  Copyright © 2018 Rifat Firdaus. All rights reserved.
//

import UIKit

class MainTabBarController: SMTabBarController {

    static func instantiate(tabBarList: [UIViewController]) -> MainTabBarController {
        let controller = UIStoryboard.sample.instantiateViewController(withIdentifier: self.className()) as! MainTabBarController
        controller.tabBarList = tabBarList
        return controller
    }
    
    static func instantiate() -> MainTabBarController {
        let controller = UIStoryboard.sample.instantiateViewController(withIdentifier: self.className()) as! MainTabBarController
        
        let repoViewController = RepoViewController.instantiateNav()
        repoViewController.tabBarItem = UITabBarItem(title: "Repositories", image: UIImage(named: "ic_folder"), tag: 0)
        
        let newsListViewController = NewsListViewController.instantiateNav()
        newsListViewController.tabBarItem = UITabBarItem(title: "News", image: UIImage(named: "ic_file"), tag: 1)
        
        let profileViewController = ProfileViewController.instantiate()
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "ic_person"), tag: 2)
        
        controller.tabBarList = [repoViewController, newsListViewController, profileViewController]
        
//        let nav = ViewManager.createNavigationController(rootController: controller)
        controller.view.backgroundColor = SMUITheme.color.primary
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialize()
        let backItem = UIBarButtonItem()
        backItem.title = " "
        self.navigationItem.backBarButtonItem = backItem
    }
}
