//
//  JobViewController.swift
//  SMV-iper
//
//  Created by Alam Akbar Muhammad on 30/07/19.
//  Copyright © 2019 Rifat Firdaus. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import SVProgressHUD

class JobViewController: UIViewController {

    var tableView: TPKeyboardAvoidingTableView!
    var presenter: JobPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackBarButtonItems()
        
        // setup ui
        tableView = SMContainerView.createTableView(viewParent: view)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addPullToRefresh { [weak self] in
            self?.presenter.refresh()
        }
        tableView.addInfiniteScrolling { [weak self] in
            self?.presenter.next()
        }
        tableView.infiniteScrollingView.enabled = false
        
        // initial data
        presenter.load()
    }

}

extension JobViewController: JobPresenterProtocol {
    func showData() {
        tableView.infiniteScrollingView.enabled = presenter.pageStatus.hasNext
        tableView.pullToRefreshView.stopAnimating()
        tableView.infiniteScrollingView.stopAnimating()
        tableView.reloadData()
    }
    
    func showError(error: Error?) {
        tableView.pullToRefreshView.stopAnimating()
        tableView.infiniteScrollingView.stopAnimating()
        SVProgressHUD.showError(withStatus: error?.localizedDescription)
    }
}

extension JobViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < presenter.items.count else {
            return UITableViewCell()
        }
        let cell = UITableViewCell()
        cell.textLabel?.text = presenter.items[indexPath.row].name
        cell.detailTextLabel?.text = presenter.items[indexPath.row].descriptionField
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let job = presenter.items[indexPath.row]
        presentJobDetail(self, jobId: job.identifier)
    }
    
}

// MARK: - Router

extension JobViewController {
    static func instantiate() -> JobViewController {
        let view = JobViewController()
        let presenter = JobPresenter()
        view.presenter = presenter
        presenter.view = view
        return view
    }
    
    static func instantiateNav() -> UINavigationController {
        let view = instantiate()
        return ViewManager.createNavigationController(rootController: view)
    }
    
    func presentJobDetail(_ target: UIViewController, jobId: Int64) {
        let view = JobDetailViewController.instantiateNav(jobId: jobId)
        target.present(view, animated: true, completion: nil)
    }
}
