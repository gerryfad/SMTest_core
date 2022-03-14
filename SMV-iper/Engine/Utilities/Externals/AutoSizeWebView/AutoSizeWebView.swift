//
//  AutoSizeWebView.swift
//  uph-mobile-ios
//
//  Created by Alam Akbar Muhammad on 17/06/20.
//  Copyright © 2020 Suitmedia. All rights reserved.
//
//  Credits: - https://stackoverflow.com/a/58805898/2537616
//           - https://www.amerhukic.com/determining-the-content-size-of-a-wkwebview
//

import UIKit
import WebKit

class AutoSizeWebView: WKWebView {
    
    var font: UIFont?
    var fontColor: UIColor?
    var heightConstraint: NSLayoutConstraint?
    
    init(frame: CGRect) {
        let configuration = WKWebViewConfiguration()
        super.init(frame: frame, configuration: configuration)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        navigationDelegate = self
        scrollView.bounces = false
        scrollView.isScrollEnabled = false
        scrollView.contentInset = UIEdgeInsets.zero
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.isActive = true
    }
    
    // use this if using invalidateIntrinsicContentSize
    //override var intrinsicContentSize: CGSize {
    //    return scrollView.contentSize
    //}
    
    func loadHTMLContent(_ htmlContent: String) {
        let font = self.font ?? UIFont.systemFont(ofSize: 12)
        let fontColor = self.fontColor ?? .black
        let props: [String: String] = [
            "margin": "0",
            "font-family": "'\(font.familyName)'",
            "font-size": "\(font.pointSize)pt",
            "color": fontColor.hexString(),
            "line-height": "18pt"
        ]
        var styleAttr = "style=\""
        styleAttr = styleAttr + props.map({ key, value in
            return "\(key): \(value);"
        }).joined(separator: " ")
        styleAttr = styleAttr + "\""
        print(styleAttr)
        let htmlStart = "<HTML><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"></HEAD><BODY \(styleAttr)>"
        let htmlEnd = "</BODY></HTML>"
        let htmlString = "\(htmlStart)\(htmlContent)\(htmlEnd)"
        loadHTMLString(htmlString, baseURL: nil)
    }
    
}

extension AutoSizeWebView: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
        //    guard let _ = complete else { return }
        //    webView.invalidateIntrinsicContentSize()
        //})
        webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { [weak self] (height, error) in
            let height: CGFloat = (height as? CGFloat) ?? 0
            self?.heightConstraint?.constant = height
        })
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url, UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
}
