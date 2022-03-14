//
//  ProfileViewController.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 09/01/19.
//  Copyright © 2019 Rifat Firdaus. All rights reserved.
//

import UIKit
import SVProgressHUD

struct ProfileItem {
    var tag: Int
    var imageProfile: UIImage?
    var title: String?
}

class ProfileViewController: SMCollectionViewController {

    @IBOutlet private weak var labelGreet: SMHeadingLabel!
    @IBOutlet private weak var viewContainer: UIView!
    @IBOutlet private weak var stackViewNameContainer: UIStackView!
    
    var presenter: ProfilePresenter!
    
    var profileItems = [
        ProfileItem(tag: 1, imageProfile: #imageLiteral(resourceName: "ic_person"), title: "Edit Profile"),
        ProfileItem(tag: 2, imageProfile: #imageLiteral(resourceName: "ic_file"), title: Lstr.language.tr(.indonesia)),
        ProfileItem(tag: 3, imageProfile: #imageLiteral(resourceName: "ic_folder"), title: "Browse Drive"),
        ProfileItem(tag: 4, imageProfile: #imageLiteral(resourceName: "ic_folder"), title: "View Image"),
        ProfileItem(tag: 5, imageProfile: #imageLiteral(resourceName: "ic_folder"), title: "View Document"),
        ProfileItem(tag: 6, imageProfile: #imageLiteral(resourceName: "ic_folder"), title: "Job"),
        ProfileItem(tag: 7, imageProfile: #imageLiteral(resourceName: "ic_folder"), title: "Panti"),
        ProfileItem(tag: 8, imageProfile: #imageLiteral(resourceName: "ic_folder"), title: "Panti Edit Profile"),
        ProfileItem(tag: 10, imageProfile: #imageLiteral(resourceName: "ic_folder"), title: "Curved Tabbar"),
        ProfileItem(tag: 9, imageProfile: #imageLiteral(resourceName: "ic_close"), title: "Close Account")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelGreet.setAttributedText(Lstr.hiX("Brian"))
        stackViewNameContainer.setBackground(color: UIColor(hexString: "#ffffff", alpha: 0.75) ?? .white, cornerRadius: 5)
        
        collectionViewForceEmbedIn(view: viewContainer)
        collectionView.register(ProfileItemCell.loadNib(), forCellWithReuseIdentifier: ProfileItemCell.className())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = false
        collectionView.alwaysBounceVertical = false // to disable bounce
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setTransparentNavbar()
        let imageViewBG = UIImageView(image: Asset.Assets.bgNavBig.image)
        view.insertSubview(imageViewBG, at: 0)
        view.addConstraintsWithFormat("H:|[v0]|", views: imageViewBG)
        view.addConstraintsWithFormat("V:|[v0]-0-[v1]", views: imageViewBG, viewContainer)
//        view.addConstraintsWithFormat("V:|[v0(200)]", views: imageViewBG)
        
        self.parent?.title = "Profile"
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.view.layoutIfNeeded()
        setupView()
    }
    
    func setupView() {
        let collectionLeftMargin: CGFloat = 16
        let collectionRightMargin: CGFloat = 16
        let cellInRow: CGFloat = 3
        let horizontalSpace: CGFloat = 8
        let cellWidth = self.collectionViewGetPrecicionCellWidth(containerSize: UIScreen.main.bounds.width, cellInRow: cellInRow, collectionLeftMargin: collectionLeftMargin, collectionRightMargin: collectionRightMargin, horizontalSpace: horizontalSpace)
        let cellHeight = cellWidth
        let cellSize = CGSize(width: cellWidth, height: cellHeight)
        let collectionPadding = UIEdgeInsets(top: 0, left: collectionLeftMargin, bottom: 0, right: collectionRightMargin)
        
        // minimumLineSpacing = Jarak antar section (Atas bawah ketika scrollDirection = .vertical)
        collectionViewSetup(cellSize: cellSize,
                            scrollDirection: .vertical,
                            padding: collectionPadding,
                            minimumLineSpacing: horizontalSpace,
                            minimumInteritemSpacing: 0)
        collectionView.reloadData()
    }

}

extension ProfileViewController: ProfilePresenterProtocol {
    func uploading(percentage: Double) {
        SVProgressHUD.showProgress(Float(percentage), status: "Updating profile")
    }
    
    func showData() {
        collectionView.reloadData()
        SVProgressHUD.showSuccess(withStatus: "Success")
    }
    
    func showError(error: Error?) {
        SVProgressHUD.showError(withStatus: error?.localizedDescription)
    }
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileItemCell.className(), for: indexPath) as! ProfileItemCell
        cell.profileItem = profileItems[indexPath.row]
        return cell
    }

    // delegate

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch profileItems[indexPath.row].tag {
        case 1:
            let controller = EditProfileViewController.instantiateNav()
//            let controller = EditProfileViewController.instantiate()
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true, completion: nil)
        case 2:
            LocaleManager.instance.viewLocale.showLanguageSheetPicker(
                controller: self,
                doneBlock: { (_, _) in
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.15) {
                        UIApplication.setRootView(LaunchHandlerViewController.instantiate())
                    }
                },
                cancelBlock: {
                    // cancel
                })
        case 3:
            FilePicker.shared.show(
                self,
                onSuccess: { [weak self] type, url, image in
                    print(self?.description ?? "")
                    print("Pick success")
                    print("Type     : \(type)")
                    print("Filename : \(url.lastPathComponent)")
                    print("Image    : \(image != nil)")
                    
                    var movedUrl = FileManager.moveFileToLocalMain(from: url)!
                    print("Move to app local main directory")
                    print("Filename : \(movedUrl)")
                    
                    movedUrl = FileManager.moveFileToLocalTemp(from: movedUrl)!
                    print("Move to app local temp directory")
                    print("Filename : \(movedUrl)")
                    
                    movedUrl = FileManager.moveFileToSystemTemp(from: movedUrl)!
                    print("Move to app system temp directory")
                    print("Filename : \(movedUrl)")
                },
                onFailed: { [weak self] type, error in
                    print(self?.description ?? "")
                    print("Pick failed")
                    print("Type     : \(type)")
                    print("Error    : \(error.localizedDescription)")
            })
        case 4:
            let url = URL(string: "https://upload.wikimedia.org/wikipedia/commons/2/29/Sierra_de_L%C3%BAjar._%285985998884%29.jpg")!
            DocumentsPreviewController.show(in: self, url: url, usingCache: false)
        case 5:
            let url = URL(string: "https://www.eurofound.europa.eu/sites/default/files/ef_publication/field_ef_document/ef1710en.pdf")!
            DocumentsPreviewController.show(in: self, url: url, usingCache: false)
        case 6:
            let nav = JobViewController.instantiateNav()
            present(nav, animated: true, completion: nil)
        case 7:
            let nav = PlaceViewController.instantiateNav()
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        case 8:
            presenter.editProfile()
        case 10:
            let controller = SMCurvedTabbarViewController.instantiate()
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true, completion: nil)
        default:
            // let url = URL(string: "https://gahp.net/wp-content/uploads/2017/09/sample.pdf")!
            // let url = URL(string: "https://www.hq.nasa.gov/alsj/a17/A17_FlightPlan.pdf")!
            // let url = URL(string: "http://iskin.tooliphone.net/themes/12361/9062/preview-256.png")!
            // let url = URL(string: Bundle.main.path(forResource: "sample", ofType: "pdf")!)!
            
            // SVProgressHUD.showInfo(withStatus: "\(profileItems[indexPath.row].title ?? "")")
            break
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct ProfileViewControllerRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let controller = ProfileViewController.instantiate()
        return controller.view
    }
    
    func updateUIView(_ view: UIView, context: Context) {
        
    }
}

@available(iOS 13.0, *)
struct ProfileViewControllerPreviews: PreviewProvider {
    static var previews: some View {
        ProfileViewControllerRepresentable()
    }
}
#endif

// MARK: - Router

extension ProfileViewController {
    static func instantiate() -> ProfileViewController {
        let view = ProfileViewController(nibName: self.className(), bundle: nil)
        let presenter = ProfilePresenter()
        view.presenter = presenter
        presenter.view = view
        return view
    }
    
    static func instantiateNav() -> UINavigationController {
        let view = instantiate()
        return ViewManager.createNavigationController(rootController: view)
    }
}
