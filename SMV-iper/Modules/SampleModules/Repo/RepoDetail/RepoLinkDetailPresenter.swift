//
//  RepoLinkDetailPresenter.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 10/3/18.
//  Copyright © 2018 Rifat Firdaus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import WebKit

protocol RepoLinkDetailProtocol: AnyObject {
    func showLoading()
}

class RepoLinkDetailPresenter: BasePresenter<Repo> {
    
    weak var view: RepoLinkDetailProtocol?
    
    func load(webView: WKWebView) {
        if let data = item {
            if let urlString = data.htmlUrl, let url = URL(string: urlString) {
                view?.showLoading()
                webView.load(URLRequest(url: url))
            }
        }
    }
    
}
