//
//  NewsDetailViewController.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 19/12/18.
//  Copyright © 2018 Rifat Firdaus. All rights reserved.
//

import UIKit
import SVProgressHUD

class NewsDetailViewController: SMScrollViewController {
    
    lazy var labelTitle = SMHeadingLabel()
    lazy var labelDate = SMSubLabel()
    lazy var labelDesc = SMNormalLabel()
    lazy var buttonShare = SMButtonCustom()
    lazy var stackViewButtonShareWrapper: UIStackView = {
       let wrapper = SMContainerView.createVerticalWrap(align: .trailing, spacing: 0, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8))
        return wrapper
    }()
    
    var presenter: NewsDetailPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupBackBarButtonItems()
        
        self.title = "News Detail"
        setupParallaxHeader(image: UIImage(named: "ic_mountain"), contentMode: .scaleAspectFill, mode: MXParallaxHeaderMode.fill, scrollNavAlpha: true)
        
        buttonShare.setTitle("Share", for: .normal)
        buttonShare.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraintsWithFormat("H:[v0(42)]", views: buttonShare)
        view.addConstraintsWithFormat("V:[v0(42)]", views: buttonShare)
        
        labelTitle.text = "Hujan Turun di Awal Pagi"
        labelDate.text = "3 Desember 2010"
        labelDesc.numberOfLines = 0
        labelDesc.lineBreakMode = .byWordWrapping
        labelDesc.text = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        """
        
        stackViewButtonShareWrapper.addArrangedSubview(buttonShare)
        
        smContainer.stackViewContainer.addArrangedSubViews(views: [stackViewButtonShareWrapper, labelTitle, labelDate, labelDesc])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // override scrollViewDelegate
    //
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        
        //
    }
}

extension NewsDetailViewController: NewsDetailPresenterProtocol {
    func showData() {
        
    }
    
    func showError(error: Error?) {
        SVProgressHUD.showError(withStatus: error?.localizedDescription)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct NewsDetailViewControllerRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let controller = NewsDetailViewController.instantiate(newsId: 0)
        return controller.view
    }
    
    func updateUIView(_ view: UIView, context: Context) {
        
    }
}

@available(iOS 13.0, *)
struct NewsDetailViewControllerPreviews: PreviewProvider {
    static var previews: some View {
        NewsDetailViewControllerRepresentable()
    }
}
#endif

// MARK: - Router

extension NewsDetailViewController {
    static func instantiate(newsId: Int) -> NewsDetailViewController {
        let view = NewsDetailViewController()
        let presenter = NewsDetailPresenter()
        view.presenter = presenter
        presenter.view = view
        return view
    }
    
    static func instantiateNav(newsId: Int) -> UINavigationController {
        let view = instantiate(newsId: newsId)
        return ViewManager.createNavigationController(rootController: view)
    }
}
