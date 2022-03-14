//
//  SMUITheme.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 14/12/18.
//  Copyright © 2018 Rifat Firdaus. All rights reserved.
//

// UITheme Version 1.0.0 January 09, 2018
// UITheme last Version 1.1.0 January 09, 2018
// Last project: None

import UIKit

struct SMButtonTheme {
    var titleColor: UIColor
    var backgroundColor: UIColor
    var font: UIFont
    var cornerRadius: CGFloat
}

struct SMLabelTheme {
    var font: UIFont
    var textColor: UIColor
}

class SMUITheme: NSObject {
    
    // Theme for SMV-iper project
    static let colorString = SMColorString()
    static let color = SMColor()
    static let buttonTheme = SMUIButton()
    static let labelTheme = SMUILabel()
    static let navBar = SMNavTheme()
    static let tabBar = SMTabBarTheme()
    
}
