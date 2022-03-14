//
//  DocumentsPreviewController.swift
//
//  Created by Rifat Firdaus on 9/25/16.
//  Copyright © 2016 Suitmedia. All rights reserved.
//

import UIKit
import QuickLook
import SVProgressHUD

class DocumentsPreviewController: QLPreviewController {

    var url: URL?
    var usingCache: Bool = true
    var headers: Headers? = nil
    var onError: ((Error) -> Void)?
    
    private lazy var loadingView = LoadingView()
    
    static func show(in controller: UIViewController, url: URL, usingCache: Bool = true, headers: Headers? = nil, onError: ((Error) -> Void)? = nil) {
        let previewController = DocumentsPreviewController()
        previewController.url = url
        previewController.usingCache = usingCache
        previewController.headers = headers
        previewController.onError = onError
        let nav = UINavigationController(rootViewController: previewController)
        nav.modalPresentationStyle = .fullScreen
        controller.present(nav, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let color = navigationController?.navigationBar.tintColor
        setupBackBarButtonItems(closeButton: true, tintColor: color)
        //setOpaqueNavbar(color: SMUITheme.navBar.backgroundColor)
        
        // Printing the doc
        self.dataSource = self
        
        showPreview()
        
        // setup loading view
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.frame = view.frame
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //navigationItem.rightBarButtonItems?[0] = UIBarButtonItem()
    }
    
    func downloadIfNeeded(onCompletion: @escaping (URL) -> Void) {
        guard let url = url else {
            reloadData()
            return
        }
        
        if url.absoluteString.hasPrefix("/") {
            onCompletion(url)
        } else {
            // remove cache if necessary
            if !usingCache, let cachedUrl = FileManager.documentFile(path: url.lastPathComponent) {
                FileManager.removeFile(at: cachedUrl)
            }
            loadingView.show()
            DownloadManager.downloadFile(url.absoluteString, headers: headers, completionHandler: { [weak self] progress, error, filePath in
                if error == nil {
                    if let progress = progress, progress >= 1.0 {
                        self?.loadingView.hide()
                        if let filePath = filePath {
                            print(filePath.absoluteString)
                            onCompletion(filePath)
                        }
                    } else {
                        self?.loadingView.show(percentage: Float(progress!))
                    }
                } else {
                    if let onError = self?.onError {
                        self?.loadingView.hide()
                        onError(error!)
                        return
                    }
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                    SVProgressHUD.dismiss(withDelay: 1.3)
                }
            })
        }
    }
    
    func showPreview() {
        downloadIfNeeded(onCompletion: { [weak self] url in
            guard let self = self else { return }
            
            self.url = url
            
            // Refreshing the view
            self.reloadData()
        })
    }
    
}

extension DocumentsPreviewController: QLPreviewControllerDataSource {
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let fileUrl: URL
        if url!.absoluteString.hasPrefix("/") {
            fileUrl = ("file://" + url!.absoluteString).toUrl()!
        } else {
            fileUrl = url!
        }
        print("[File Location: \(fileUrl)]")
        return fileUrl as QLPreviewItem
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return url != nil ? 1 : 0
    }
}

fileprivate class LoadingView: UIView {
    
    lazy var label = UILabel()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        isHidden = true
        isUserInteractionEnabled = false
        backgroundColor = .white
        
        let content = SMContainerView.createVerticalWrap()
        content.alignment = .center
        content.spacing = 8
        addSubview(content)
        
        let indicator = UIActivityIndicatorView()
        indicator.heightAnchor.constraint(equalToConstant: 24).isActive = true
        indicator.widthAnchor.constraint(equalToConstant: 24).isActive = true
        indicator.color = .lightGray
        indicator.startAnimating()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.text = "Loading"
        content.addArrangedSubview(indicator)
        content.addArrangedSubview(label)
        
        content.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint.createCenterXConstraint(view: content, toView: self),
            NSLayoutConstraint.createCenterYConstraint(view: content, toView: self)
        ])
    }
    
    func show(percentage: Float? = nil) {
        if let percentage = percentage {
            label.text = "Loading " + String(format: "%.0f%%", percentage * 100)
        } else {
            label.text = "Loading"
        }
        isHidden = false
    }
    
    func hide() {
        isHidden = true
    }
    
}
