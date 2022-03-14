//
//  UILabelExtension.swift
//  uph-mobile-ios
//
//  Created by Alam Akbar Muhammad on 22/07/20.
//  Copyright © 2020 Suitmedia. All rights reserved.
//

extension UILabel {
    func setAttributedText(_ value: String) {
        let attributedText = self.attributedText ?? NSAttributedString(string: value)
        let attributedString = NSMutableAttributedString(attributedString: attributedText)
        attributedString.mutableString.setString(value)
        self.attributedText = attributedString
    }
}
