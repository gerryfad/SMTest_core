//
//  SMCurvedTabbarViewController.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 27/03/20.
//  Copyright © 2020 Rifat Firdaus. All rights reserved.
//

import UIKit
import Popover

class SMCurvedTabbarViewController: UITabBarController {

    let buttonCenter = SMButtonCustom()
    
    static func instantiate() -> SMCurvedTabbarViewController {
        let controller = UIStoryboard.sample.instantiateViewController(withIdentifier: self.className()) as! SMCurvedTabbarViewController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonCenter.setImage(UIImage(named: "ic_file"), for: .normal)
        buttonCenter.layer.cornerRadius = 35
        self.view.addSubview(buttonCenter)
        
        buttonCenter.addTarget(self, action: #selector(didPressedButtonCenter), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presentingViewController?.view.alpha = 0.3
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.presentingViewController?.view.alpha = 1
    }
    
    override func viewDidLayoutSubviews() {
        var subtractor: CGFloat = 180
        if UIApplication.shared.statusBarOrientation.isLandscape {
            subtractor = 115
        }
        buttonCenter.frame = CGRect(x: UIScreen.main.bounds.width * 0.5 - 35, y: (UIScreen.main.bounds.height - subtractor), width: 70, height: 70)
    }
    
    @objc private func didPressedButtonCenter(sender: SMButton) {
        print("pressed")
        let controller = SMPopupMenuViewController.instantiate()
        controller.view.backgroundColor = .white
        let popover = Popover()
        popover.popoverType = PopoverType.up
        popover.show(controller.view, fromView: sender)
    }
    
}

extension SMCurvedTabbarViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}
