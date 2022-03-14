//
//  RepoLinkDetailViewController.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 10/3/18.
//  Copyright © 2018 Rifat Firdaus. All rights reserved.
//

import UIKit
import WebKit

class RepoLinkDetailViewController: UIViewController {

    var webView: WKWebView!
    
    var presenter = RepoLinkDetailPresenter()
    lazy var loadingView = ViewManager.createLoadingFullScreen(offset: 64)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraintsWithFormat("H:|-0-[v0]-0-|", views: webView)
        self.view.addConstraintsWithFormat("V:|-0-[v0]-0-|", views: webView)
        
        webView.navigationDelegate = self
        presenter.load(webView: webView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "\(presenter.item?.name ?? "")"
    }
    
}

extension RepoLinkDetailViewController: RepoLinkDetailProtocol {
    func showLoading() {
        ViewManager.addSubView(loadingView: loadingView, to: webView)
    }
}

extension RepoLinkDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish")
        loadingView.removeFromSuperview()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("error")
        loadingView.removeFromSuperview()
    }
}

// MARK: - Router

extension RepoLinkDetailViewController {
    static func instantiate(repo: Repo) -> RepoLinkDetailViewController {
        let view = UIStoryboard.sample.instantiateViewController(withIdentifier: RepoLinkDetailViewController.className()) as! RepoLinkDetailViewController
        let presenter = RepoLinkDetailPresenter()
        presenter.item = repo
        view.presenter = presenter
        presenter.view = view
        return view
    }
    
    static func instantiateNav(repo: Repo) -> UINavigationController {
        let view = instantiate(repo: repo)
        return ViewManager.createNavigationController(rootController: view, transparent: true)
    }
}
