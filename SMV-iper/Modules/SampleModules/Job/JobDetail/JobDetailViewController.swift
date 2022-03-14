//
//  JobDetailViewController.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 19/12/18.
//  Copyright © 2018 Rifat Firdaus. All rights reserved.
//

import UIKit
import SVProgressHUD

class JobDetailViewController: SMScrollViewController {
    
    lazy var labelTitle = SMHeadingLabel()
    lazy var labelDate = SMSubLabel()
    lazy var labelDesc = SMNormalLabel()
    lazy var buttonShare = SMButtonCustom()
    lazy var stackViewButtonShareWrapper: UIStackView = {
        let wrapper = SMContainerView.createVerticalWrap(align: .trailing, spacing: 0, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8))
        return wrapper
    }()
    
    var presenter: JobDetailPresenter!
    var jobId: Int64 = 0
    
    convenience init(jobId: Int64) {
        self.init()
        self.jobId = jobId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackBarButtonItems()
        
        presenter.load(id: jobId)
        
        self.title = "Job Detail"
        setupParallaxHeader(image: UIImage(named: "ic_mountain"), contentMode: .scaleAspectFill, mode: MXParallaxHeaderMode.fill, scrollNavAlpha: true)
        
        buttonShare.setTitle("Share", for: .normal)
        buttonShare.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraintsWithFormat("H:[v0(42)]", views: buttonShare)
        view.addConstraintsWithFormat("V:[v0(42)]", views: buttonShare)
        
        labelTitle.text = "Hujan Turun di Awal Pagi"
        labelDate.text = "3 Desember 2010"
        labelDesc.numberOfLines = 0
        labelDesc.lineBreakMode = .byWordWrapping
        labelDesc.text = "To be replaced"
        
        stackViewButtonShareWrapper.addArrangedSubview(buttonShare)
        
        smContainer.stackViewContainer.addArrangedSubViews(views: [stackViewButtonShareWrapper, labelTitle, labelDate, labelDesc])
        
        smContainer.scrollView.addPullToRefresh { [weak self] in
            guard let jobId = self?.jobId else {
                return
            }
            self?.presenter.refresh(jobId: jobId)
        }
        
        reloadView()
    }
    
    func reloadView() {
        labelTitle.text = presenter.item?.name
        labelDesc.text = presenter.item?.descriptionField
    }
    
}

extension JobDetailViewController: JobDetailPresenterProtocol {
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

extension JobDetailViewController {
    static func instantiate(jobId: Int64) -> JobDetailViewController {
        let view = JobDetailViewController(jobId: jobId)
        view.jobId = jobId
        let presenter = JobDetailPresenter()
        view.presenter = presenter
        presenter.view = view
        return view
    }
    
    static func instantiateNav(jobId: Int64) -> UINavigationController {
        let view = instantiate(jobId: jobId)
        return ViewManager.createNavigationController(rootController: view, transparent: true)
    }
}
