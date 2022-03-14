//
//  PlaceCollectionViewController.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 18/10/19.
//  Copyright © 2019 Rifat Firdaus. All rights reserved.
//

import UIKit
import SVPullToRefresh
import SVProgressHUD

class PlaceCollectionViewController: SMCollectionViewController {

    var presenter: PlacePresenter
    weak var parentController: PlaceViewController!
    var viewContainer: UIView
    
    init(parentController: PlaceViewController, embedView view: UIView, presenter: PlacePresenter) {
        self.presenter = presenter
        self.viewContainer = view
        self.parentController = parentController
        super.init(nibName: nil, bundle: nil)
        
        self.setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        collectionViewForceEmbedIn(view: viewContainer)
        // Register cell without Nib
        collectionView.register(PlaceCell.self, forCellWithReuseIdentifier: PlaceCell.className())
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = false
        collectionView.isUserInteractionEnabled = true
        collectionView.alwaysBounceVertical = true // to disable bounce
        collectionView.addPullToRefresh { [weak self] in
            self?.refreshData()
        }
        collectionView.addInfiniteScrolling { [weak self] in
            self?.presenter.next()
        }
        collectionViewSetup(scrollDirection: .vertical)
    }
    
    private func refreshData() {
        self.presenter.refresh()
    }
    
    func updateSource() {
        collectionView.infiniteScrollingView.enabled = presenter.items.count != 0
        collectionView.pullToRefreshView.stopAnimationLoading()
        collectionView.infiniteScrollingView.stopAnimationLoading()
        collectionView.reloadData()
    }
    
}

extension PlaceCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceCell.className(), for: indexPath) as! PlaceCell
        cell.place = presenter.items[indexPath.row]
        return cell
    }
    
    // Header Footer view
    //
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind {
//        case UICollectionView.elementKindSectionHeader:
//            return header
//        case UICollectionView.elementKindSectionFooter:
//            return footer
//        default:
//            return UICollectionReusableView()
//        }
//    }

    // delegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let place = presenter.items[indexPath.row]
        let nav = parentController.navigationController!
        parentController.presentToPlaceDetail(nav, placeId: place.identifier)
    }
}

extension PlaceCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculate dynamic height
        let verticalMargin: CGFloat = 72
        var estimatedNameFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 25)
        var estimatedAddressFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        var imageHeight: CGFloat = 0
        if indexPath.row < presenter.items.count {
            let place = presenter.items[indexPath.row]
            let approximateText = UIScreen.main.bounds.width - 64
            let size = CGSize(width: approximateText, height: 1000)
            let attributesName = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
            let attributesAddress = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
            estimatedNameFrame = NSString(string: place.name ?? "").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributesName, context: nil)
            estimatedAddressFrame = NSString(string: place.address ?? "").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributesAddress, context: nil)
            if let image = place.coverImage.first {
                if image.imageRatio > 0 {
                    imageHeight = CGFloat(UIScreen.main.bounds.width - 64) * CGFloat(image.imageRatio)
                }
            }
        }
        return CGSize(width: UIScreen.main.bounds.width, height: estimatedNameFrame.height + estimatedAddressFrame.height + verticalMargin + imageHeight)
    }
    
    // Header and footer
    //
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize.zero
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return CGSize.zero
//    }
    
}
