//
//  PlaceTableViewController.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 10/10/19.
//  Copyright © 2019 Rifat Firdaus. All rights reserved.
//

import UIKit
import SVPullToRefresh

class PlaceTableViewController: SMTableViewController {
    
    private var presenter = PlacePresenter()
    private var mainController = UIViewController()

    static func instantiate(mainController: UIViewController, embedInView view: UIView, presenter: PlacePresenter) -> PlaceTableViewController {
        let controller = PlaceTableViewController()
        controller.presenter = presenter
        controller.mainController = mainController
        controller.forceEmbedTableViewInView(view: view)
        controller.setupTableView()
        return controller
    }
    
    private func setupTableView() {
        setupDefaultTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addPullToRefresh { [weak self] in
            self?.presenter.refresh()
        }
        tableView.addInfiniteScrolling { [weak self] in
            self?.presenter.next()
        }
    }
    
    func updateSource() {
        tableView.infiniteScrollingView.enabled = presenter.items.count != 0
        tableView.pullToRefreshView.stopAnimationLoading()
        tableView.infiniteScrollingView.stopAnimationLoading()
        tableView.reloadData()
    }
}

extension PlaceTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < presenter.items.count else {
            return UITableViewCell()
        }
        let cell = UITableViewCell()
        cell.textLabel?.numberOfLines = 3
        cell.textLabel?.text = presenter.items[indexPath.row].name
        cell.detailTextLabel?.text = presenter.items[indexPath.row].descriptionField
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = presenter.items[indexPath.row]
        let nav = PlaceDetailViewController.instantiateNav(placeId: place.identifier)
        nav.modalPresentationStyle = .fullScreen
        mainController.present(nav, animated: true, completion: nil)
    }
    
}
