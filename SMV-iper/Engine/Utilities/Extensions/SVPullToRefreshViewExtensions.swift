//
//  SVPullToRefreshViewExtensions.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 08/10/19.
//  Copyright © 2019 Rifat Firdaus. All rights reserved.
//

import Foundation
import SVPullToRefresh

extension SVPullToRefreshView {
    
    func stopAnimationLoading() {
        if self.state == SVPullToRefreshState.loading {
            self.stopAnimating()
        }
    }
    
}

extension SVInfiniteScrollingView {
    
    func stopAnimationLoading() {
        if self.state == SVInfiniteScrollingStateLoading {
            self.stopAnimating()
        }
    }
    
}
