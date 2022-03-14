//
//  PlaceViewController.swift
//  SMV-iper
//
//  Created by Alam Akbar Muhammad on 30/07/19.
//  Copyright © 2019 Rifat Firdaus. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import SVProgressHUD

class TabController: UITabBarController {
    
}

class TableController: UITableViewController {
    
}

class HomeViewController: UIViewController {
    
    func registerCells() {
        
    }
    
    func setCustomTableViewConfig() {
        
    }
    
}

//    class HomePage: UIViewController {
//        func registerCells() {
//
//        }
//
//        func setCustomTableViewConfig() {
//
//        }
//    }

class PlaceViewController: UIViewController {

    var presenter: PlacePresenter!
    // var placeTableViewController: PlaceTableViewController!
    var placeCollectionViewController: PlaceCollectionViewController!
    
    // test swiftlint
//    let mvvm = PlacePresenter()
//    let tesTextField = UITextField()
//    let tesTextView = UITextView()
    let textFieldCakep = UITextField()
    let textViewCakep = UITextView()
    let presenterCakep = PlacePresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackBarButtonItems()
        title = "Place List"
        
        presenter.load()
        
        // placeTableViewController = PlaceTableViewController.instantiate(mainController: self, embedInView: self.view, presenter: self.presenter)
        placeCollectionViewController = PlaceCollectionViewController(parentController: self, embedView: self.view, presenter: presenter)
    }

}

extension PlaceViewController: PlacePresenterProtocol {
    func showData() {
        placeCollectionViewController.updateSource()
    }
    
    func showError(error: Error?) {
        placeCollectionViewController.updateSource()
        SVProgressHUD.showError(withStatus: error?.localizedDescription)
    }
}

// MARK: - Router

extension PlaceViewController {
    static func instantiate() -> PlaceViewController {
        let view = PlaceViewController()
        let presenter = PlacePresenter()
        view.presenter = presenter
        presenter.view = view
        return view
    }
    
    static func instantiateNav() -> UINavigationController {
        let view = instantiate()
        return ViewManager.createNavigationController(rootController: view)
    }
    
    func presentToPlaceDetail(_ target: UINavigationController, placeId: Int64) {
        let view = PlaceDetailViewController.instantiateNav(placeId: placeId)
        view.modalPresentationStyle = .fullScreen
        target.present(view, animated: true, completion: nil)
    }
}
