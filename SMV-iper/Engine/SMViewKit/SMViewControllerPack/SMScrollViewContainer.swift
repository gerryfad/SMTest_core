//
//  SMScrollViewContainer.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 13/12/18.
//  Copyright © 2018 Rifat Firdaus. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding

class SMScrollViewContainer: NSObject {

    let scrollView = TPKeyboardAvoidingScrollView()
    let viewContainer = UIView()
    let stackViewContainer = UIStackView()
    
    func addUIViewToScrollView(view: UIView) {
        stackViewContainer.addArrangedSubview(view)
    }
    
    func addUIViewsToScrollView(views: [UIView]) {
        stackViewContainer.addArrangedSubViews(views: views)
    }
    
    func addStackViewToScrollView(stackView: UIStackView) {
        stackViewContainer.addArrangedSubview(stackView)
    }
    
    func addStackViewsToScrollView(stackViews: [UIStackView]) {
        stackViewContainer.addArrangedSubViews(views: stackViews)
    }
}
