//
//  RepoViewController.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 10/3/18.
//  Copyright © 2018 Rifat Firdaus. All rights reserved.
//

import UIKit
import SVPullToRefresh
import TPKeyboardAvoiding
import DZNEmptyDataSet

class RepoViewController: UIViewController {

    var tableView: TPKeyboardAvoidingTableView!
    var presenter: RepoPresenter!
    lazy var viewShimmer = SimpleListShimmerView()
    
    var searchController = UISearchController(searchResultsController: nil)
    var timer: Timer?
    
    var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Repositories"
        
        setupTableView()
        setupSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let searchText = self.searchController.searchBar.text {
            if self.presenter.items.count == 0 {
                self.refresh(searchText: searchText)
            }
        }
        
        self.tabBarController?.tabBar.isHidden = false
    }

    @objc func searchText(sender: Any?) {
        if self.searchController.searchBar.text != nil && self.searchController.searchBar.text != "" {
            self.refresh(searchText: self.searchController.searchBar.text ?? "scotteg")
        }
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.searchBar.text = "scotteg"
        searchController.searchBar.sizeToFit()
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        // remove underlines_navbar and searchBar_border
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.backgroundColor = SMUITheme.color.primary
        searchController.searchBar.barTintColor = SMUITheme.color.primary
        searchController.dimsBackgroundDuringPresentation = false
    }
    
    func setupTableView() {
        tableView = SMContainerView.createTableView(viewParent: self.view)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 75
        tableView.register(RepoCell.loadNib(), forCellReuseIdentifier: RepoCell.className())
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .automatic
        } else {
            // fix If tableView is under tabbar
            //
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        // fix If tableView is under tabbar
        //
        self.edgesForExtendedLayout = UIRectEdge()
        self.extendedLayoutIncludesOpaqueBars = false
        
        // TEST SHIMMER
        //
        tableView.register(UINib(nibName: "ShimmerRepoCell", bundle: nil), forCellReuseIdentifier: "ShimmerRepoCell")
        
        tableView.addPullToRefresh { [weak self] in
            if let searchText = self?.searchController.searchBar.text, self?.searchController.searchBar.text != "" {
                self?.refresh(searchText: searchText)
            } else {
                self?.tableView.pullToRefreshView.stopAnimating()
            }
        }
        tableView.addInfiniteScrolling { [weak self] in
            if let searchText = self?.searchController.searchBar.text, self?.searchController.searchBar.text != "" {
                self?.presenter.next(user: searchText)
            } else {
                self?.tableView.infiniteScrollingView.stopAnimating()
            }
        }
        view.layoutIfNeeded()
        tableView.layoutIfNeeded()
    }
    
    func refresh(searchText: String) {
        self.tableView.pullToRefreshView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.presenter.refresh(user: searchText)
        }
    }
}

extension RepoViewController: RepoPresenterProtocol {
    func showData() {
        let tabbarController = self.tabBarController as? SMTabBarController
        if self.presenter.items.count == 0 {
            tabbarController?.tabBar.items?[0].badgeValue = nil
        } else {
            tabbarController?.tabBar.items?[0].badgeValue = "\(self.presenter.items.count)"
            tabbarController?.tabBar.items?[1].badgeValue = "1"
        }
        tableView.infiniteScrollingView.enabled = self.presenter.items.count != 0
        tableView.pullToRefreshView.stopAnimationLoading()
        tableView.infiniteScrollingView.stopAnimationLoading()
        tableView.reloadData()
    }
    
    func showError(error: Error?) {
        tableView.pullToRefreshView.stopAnimating()
    }
}

extension RepoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoCell.className(), for: indexPath) as! RepoCell
        if indexPath.row < presenter.items.count {
            cell.repo = presenter.items[indexPath.row]
        }
        return cell
        
        // TEST SHIMMER
        //
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ShimmerRepoCell", for: indexPath)
//        return cell
    }
    
    // delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        pushToRepoDetail(navigationController!, repo: presenter.items[indexPath.row])
    }
    
}

extension RepoViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(searchText(sender:)), userInfo: nil, repeats: false)
    }
}

extension RepoViewController: UISearchControllerDelegate {
    
    func willDismissSearchController(_ searchController: UISearchController) {
        searchText = searchController.searchBar.text ?? ""
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        searchController.searchBar.text = searchText
    }
    
}

extension RepoViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.refresh(searchText: searchText)
        searchController.dismiss(animated: true, completion: nil)
    }
    
}

extension RepoViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        return viewShimmer
    }
}

// MARK: - Router

extension RepoViewController {
    static func instantiate() -> RepoViewController {
        let view = UIStoryboard.sample.instantiateViewController(withIdentifier: self.className()) as! RepoViewController
        let presenter = RepoPresenter()
        view.presenter = presenter
        presenter.view = view
        return view
    }

    static func instantiateNav() -> UINavigationController {
        let view = instantiate()
        return ViewManager.createNavigationController(rootController: view, transparent: false)
    }
    
    func pushToRepoDetail(_ target: UINavigationController, repo: Repo) {
        let view = RepoLinkDetailViewController.instantiate(repo: repo)
        view.hidesBottomBarWhenPushed = true
        target.pushViewController(view, animated: true)
    }
}
