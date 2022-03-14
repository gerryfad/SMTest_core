//
//  NewsListViewController.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 18/12/18.
//  Copyright © 2018 Rifat Firdaus. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import DZNEmptyDataSet
import SVProgressHUD

class NewsListViewController: UIViewController {

    lazy var viewShimmer = SimpleListShimmerView()
    var tableView: TPKeyboardAvoidingTableView!
    
    var presenter: NewsListPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.title = Lstr.repository.tr()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.parent?.title = Lstr.news.tr()
    }
    
    func setupTableView() {
        self.loadViewIfNeeded()
        tableView = SMContainerView.createTableView(viewParent: self.view)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.className())
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }

}

extension NewsListViewController: NewsListPresenterProtocol {
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

extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.className(), for: indexPath) as! NewsCell
        cell.labelTitle.text = "Alam Achbarz"
        return cell
    }
}

extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presentToNewsDetail(self, newsId: 0)
    }
}

extension NewsListViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        return viewShimmer
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct NewsListViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let controller = UIStoryboard.sample.instantiateViewController(withIdentifier: NewsListViewController.className()) as! NewsListViewController
        return controller.view
    }
    
    func updateUIView(_ view: UIView, context: Context) {
        
    }
}

@available(iOS 13.0, *)
struct NewsListViewControllerPreviews: PreviewProvider {
    static var previews: some View {
        NewsListViewRepresentable()
    }
}
#endif

// MARK: - Router

extension NewsListViewController {
    static func instantiate() -> NewsListViewController {
        let view = UIStoryboard.sample.instantiateViewController(withIdentifier: self.className()) as! NewsListViewController
        let presenter = NewsListPresenter()
        view.presenter = presenter
        presenter.view = view
        return view
    }
    
    static func instantiateNav() -> UINavigationController {
        let view = instantiate()
        return ViewManager.createNavigationController(rootController: view)
    }
    
    func presentToNewsDetail(_ target: UIViewController, newsId: Int) {
        let view = NewsDetailViewController.instantiateNav(newsId: newsId)
        target.present(view, animated: true, completion: nil)
    }
}
