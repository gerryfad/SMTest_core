//
//  PlaceDetailViewController.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 19/12/18.
//  Copyright © 2018 Rifat Firdaus. All rights reserved.
//

import UIKit
import SVProgressHUD

class PlaceDetailViewController: SMScrollViewController {
    
    lazy var labelTitle = SMHeadingLabel()
    lazy var labelDate = SMSubLabel()
    lazy var labelDesc = SMNormalLabel()
    lazy var buttonShare = SMButtonCustom()
    lazy var stackViewButtonShareWrapper: UIStackView = {
        let wrapper = SMContainerView.createVerticalWrap(align: .trailing, spacing: 0, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8))
        return wrapper
    }()
    
    var presenter: PlaceDetailPresenter!
    var placeId: Int64 = 0
    
    convenience init(placeId: Int64) {
        self.init()
        self.placeId = placeId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupBackBarButtonItems()
        
        presenter.load(id: placeId)
        
        self.title = "Place Detail"
        setupParallaxHeader(image: UIImage(named: "ic_mountain"), contentMode: .scaleAspectFill, mode: MXParallaxHeaderMode.fill, scrollNavAlpha: true)
        
        buttonShare.setTitle("Share", for: .normal)
        buttonShare.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraintsWithFormat("H:[v0(42)]", views: buttonShare)
        view.addConstraintsWithFormat("V:[v0(42)]", views: buttonShare)
        buttonShare.addTarget(self, action: #selector(buttonShareDidTap(_:)), for: .touchUpInside)
        
        labelTitle.text = "Hujan Turun di Awal Pagi"
        labelDate.text = "3 Desember 2010"
        labelDesc.numberOfLines = 0
        labelDesc.lineBreakMode = .byWordWrapping
        labelDesc.text = "To be replaced"
        
        stackViewButtonShareWrapper.addArrangedSubview(buttonShare)
        
        smContainer.stackViewContainer.addArrangedSubViews(views: [stackViewButtonShareWrapper, labelTitle, labelDate, labelDesc])
        
        smContainer.scrollView.addPullToRefresh { [weak self] in
            guard let placeId = self?.placeId else {
                return
            }
            self?.presenter.refresh(placeId: placeId)
        }
        
        reloadView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.refresh(placeId: placeId)
    }
    
    func reloadView() {
        labelTitle.text = presenter.item?.name
        labelDesc.text = presenter.item?.descriptionField
        
        if let image = presenter.item?.placeCategory?.image?.toUrl() {
            imageViewHeader.af_setImage(withURL: image)
        }
    }
    
    @objc func buttonShareDidTap(_ sender: Any) {
        presenter.create()
    }
    
}

extension PlaceDetailViewController: PlaceDetailPresenterProtocol {
    func showData() {
        smContainer.scrollView.pullToRefreshView.stopAnimating()
        reloadView()
    }
    
    func showError(error: Error?) {
        smContainer.scrollView.pullToRefreshView.stopAnimating()
        SVProgressHUD.showError(withStatus: error?.localizedDescription)
    }
}

// MARK: - Router

extension PlaceDetailViewController {
    static func instantiate(placeId: Int64) -> PlaceDetailViewController {
        let view = PlaceDetailViewController()
        view.placeId = placeId
        let presenter = PlaceDetailPresenter()
        view.presenter = presenter
        presenter.view = view
        return view
    }
    
    static func instantiateNav(placeId: Int64) -> UINavigationController {
        let view = instantiate(placeId: placeId)
        return ViewManager.createNavigationController(rootController: view)
    }
}
