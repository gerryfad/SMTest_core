//
//  PlaceCell.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 18/10/19.
//  Copyright © 2019 Rifat Firdaus. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

protocol PlaceCellDelegate: AnyObject {
    func test(_ cell: PlaceCell)
}

class PlaceCell: UICollectionViewCell {
    
    weak var delegate: PlaceCellDelegate?
    
    var viewContainer: UIView!
    var stackView: UIStackView!
    var labelTitle: UILabel!
    var labelAddress: UILabel!
    var imageViewPlace: UIImageView!
    
    var place: Place? {
        didSet {
            if let place = place {
                let approximateText = UIScreen.main.bounds.width - 64
                let size = CGSize(width: approximateText, height: 1000)
                let attributesName = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
                let estimatedNameFrame = NSString(string: place.name ?? "").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributesName, context: nil)
                labelTitle.text = place.name?.capitalized ?? ""
                NSLayoutConstraint.activate([
                    NSLayoutConstraint.createHeightConstraint(view: labelTitle, constant: estimatedNameFrame.height)
                ])
                labelAddress.text = place.address ?? ""
                if let image = place.coverImage.first, let imageString = image.image {
                    imageViewPlace.isHidden = false
                    if image.imageRatio > 0 {
                        NSLayoutConstraint.activate([
                            NSLayoutConstraint.createHeightConstraint(view: imageViewPlace, constant: (UIScreen.main.bounds.width - 64) * CGFloat(image.imageRatio))
                        ])
                    }
                    if imageString != "" {
                        if let url = URL(string: imageString) {
                            imageViewPlace.af_setImage(withURL: url, placeholderImage: UIImage(named: "ic_news"), imageTransition: .crossDissolve(0.5))
                        }
                    }
                } else {
                    imageViewPlace.isHidden = true
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        
        viewContainer = UIView()
        viewContainer.backgroundColor = .groupTableViewBackground
        
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        
        labelTitle = {
            let labelTitle = UILabel()
            labelTitle.font = .boldSystemFont(ofSize: 14)
            labelTitle.translatesAutoresizingMaskIntoConstraints = false
            labelTitle.numberOfLines = 0
            labelTitle.lineBreakMode = .byWordWrapping
            return labelTitle
        }()
        
        labelAddress = {
            let labelAddress = UILabel()
            labelAddress.font = .systemFont(ofSize: 12)
            labelAddress.translatesAutoresizingMaskIntoConstraints = false
            labelAddress.numberOfLines = 0
            labelAddress.lineBreakMode = .byWordWrapping
            return labelAddress
        }()
        
        imageViewPlace = {
            let imageViewPlace = UIImageView()
            imageViewPlace.translatesAutoresizingMaskIntoConstraints = false
            imageViewPlace.clipsToBounds = true
            imageViewPlace.contentMode = .scaleAspectFill
//            imageViewPlace.isHidden = true
            return imageViewPlace
        }()
        
        NSLayoutConstraint.addSubviewAndCreateArroundEqualConstraint(in: viewContainer, toView: self, constant: 16)
        NSLayoutConstraint.addSubviewAndCreateArroundEqualConstraint(in: stackView, toView: viewContainer, constant: 16)
        stackView.addArrangedSubViews(views: [
            labelTitle, imageViewPlace, labelAddress
        ])
    }
    
}
