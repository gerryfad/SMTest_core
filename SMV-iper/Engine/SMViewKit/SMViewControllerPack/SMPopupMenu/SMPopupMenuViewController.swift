//
//  SMPopupMenuViewController.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 31/03/20.
//  Copyright © 2020 Rifat Firdaus. All rights reserved.
//

import UIKit

class SMPopupMenuViewController: UIViewController {

    static func instantiate() -> SMPopupMenuViewController {
        let controller =  SMPopupMenuViewController(nibName: self.className(), bundle: nil)
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
