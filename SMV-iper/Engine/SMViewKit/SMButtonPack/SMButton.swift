//
//  SMButton.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 15/12/18.
//  Copyright © 2018 Rifat Firdaus. All rights reserved.
//

import UIKit

class SMButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        self.addTarget(self, action: #selector(tappedDown), for: .touchDown)
        self.addTarget(self, action: #selector(tappedCancel), for: .touchCancel)
        self.addTarget(self, action: #selector(tappedCancel), for: .touchDragOutside)
    }
    
    @objc private func tapped(sender: SMButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.6
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 1.0
            })
        })
    }
    
    @objc private func tappedDown(sender: SMButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.6
        }, completion: nil)
    }
    
    @objc private func tappedCancel(sender: SMButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    
}
