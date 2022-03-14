//
//  ThirdViewController.swift
//  SMV-iper
//
//  Created by yaelahbro on 12/03/22.
//  Copyright © 2022 Rifat Firdaus. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import DZNEmptyDataSet
import SVProgressHUD


class ThirdViewController: UIViewController{
    
    lazy var viewShimmer = SimpleListShimmerView()
    var tableView: TPKeyboardAvoidingTableView!
    var presenter: ThirdPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Third Screen"
        setupTableView()
        refresh()
        
        
    }
    

    func setupTableView() {
        view.layoutIfNeeded()

        tableView = SMContainerView.createTableView(viewParent: self.view)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.addPullToRefresh { [weak self] in
            self?.refresh()
        }
        tableView.addInfiniteScrolling { [weak self] in
            self?.presenter.next()
        }
    }
    
   
    func refresh() {
        self.tableView.pullToRefreshView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.presenter.refresh()
        }
    }
    

}

extension ThirdViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier) as! UserTableViewCell
        if indexPath.row < presenter.items.count {
            let user = presenter.items[indexPath.row]
            cell.set(user: user)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = presenter.items[indexPath.row]
        let selectedUser = "\(user.firstName!) \(user.lastName!)"
        navigationController?.popViewController(animated: true)
        presenter.view?.selectUser(select: selectedUser)
        print(selectedUser)
        
       
       
        
    }
}


extension ThirdViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        return viewShimmer
    }
}

extension ThirdViewController: ThirdPresenterProtocol, SecondPresenterProtocol{
    func selectUser(select: String) {
        
    }
    
    func selectUsername(select: String) {
        
    }
    
    
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


extension ThirdViewController {
    static func instantiate() -> ThirdViewController {
        let view = ThirdViewController()
        let presenter = ThirdPresenter()
        view.presenter = presenter
        presenter.view = view
        return view
    }
    
    static func instantiateNav() -> UINavigationController {
        let view = instantiate()
        return ViewManager.createNavigationController(rootController: view)
    }
    
    
}
