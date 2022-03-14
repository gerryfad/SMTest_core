//
//  SimpleListShimmerView.swift
//  uph-mobile-ios
//
//  Created by Alam Akbar Muhammad on 24/06/20.
//  Copyright © 2020 Suitmedia. All rights reserved.
//

import Foundation

class SimpleListShimmerView: BaseShimmerView {
    
    override func contentView() -> UIView {
        let view = Bundle.main.loadNibNamed(SimpleListShimmerView.className(), owner: self, options: nil)?.first as! UIView
        return view
    }
    
}
