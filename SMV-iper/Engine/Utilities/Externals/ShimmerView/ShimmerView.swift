//
//  ShimmerView.swift
//  uph-mobile-ios
//
//  Created by Alam Akbar Muhammad on 08/06/20.
//  Copyright © 2020 Suitmedia. All rights reserved.
//

import Foundation

class BaseShimmerView: UIView {
    
    private var _contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        _contentView.removeFromSuperview()
        _contentView = contentView()
        _contentView.showShimmer()
        
        self.addSubview(_contentView)
        _contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraintsWithFormat("H:|-0-[v0]-0-|", views: _contentView)
        self.addConstraintsWithFormat("V:|-0-[v0]", views: _contentView)
    }
    
    func contentView() -> UIView {
        return UIView()
    }
    
}

private var shimmerKey: Void? = nil

extension UIView {
    
    @IBInspectable
    var shimmerEnabled: Bool {
        get { return objc_getAssociatedObject(self, &shimmerKey) as? Bool ?? false }
        set { objc_setAssociatedObject(self, &shimmerKey, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
    func showShimmer(bgColor: UIColor? = nil) {
        subviews.forEach{ view in
            view.showShimmer()
        }
        guard self.shimmerEnabled else { return }
        let color = bgColor ?? #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.937254902, alpha: 1)
        self.backgroundColor = color
        (self as? UIImageView)?.backgroundColor = color
        (self as? UIImageView)?.image = nil
        (self as? UILabel)?.backgroundColor = color
        (self as? UILabel)?.textColor = .clear
        (self as? UILabel)?.text = " "
        (self as? UIButton)?.tintColor = color
        (self as? UIButton)?.titleLabel?.textColor = .clear
        self.cornerRadius = min(4, self.frame.height / 2.0)
        startShimmering()
    }
    
    func hideShimmer() {
        subviews.forEach{ view in
            view.hideShimmer()
        }
        guard self.shimmerEnabled else { return }
        stopShimmering()
    }
    
}
