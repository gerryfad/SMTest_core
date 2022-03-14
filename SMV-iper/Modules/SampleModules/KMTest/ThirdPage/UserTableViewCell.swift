//
//  UserTableViewCell.swift
//  SMV-iper
//
//  Created by yaelahbro on 12/03/22.
//  Copyright © 2022 Rifat Firdaus. All rights reserved.
//

import UIKit
import SDWebImage

class UserTableViewCell: UITableViewCell {
    
    static let identifier = "UserTableViewCell"
    
    let imageViewAvatar: UIImageView = {
        let imageViewAddphoto = UIImageView()
        imageViewAddphoto.layer.cornerRadius = 25
        imageViewAddphoto.clipsToBounds = true
        imageViewAddphoto.translatesAutoresizingMaskIntoConstraints = false
        return imageViewAddphoto
    }()
    
    let labelUsername: UILabel = {
        let labelUsername = UILabel()
        labelUsername.font = UIFont.boldSystemFont(ofSize: 16)
        labelUsername.translatesAutoresizingMaskIntoConstraints = false
        return labelUsername
    }()
    
    let labelEmail: UILabel = {
        let labelUsername = UILabel()
        labelUsername.font = UIFont.systemFont(ofSize: 12)
        labelUsername.translatesAutoresizingMaskIntoConstraints = false
        return labelUsername
    }()

    
    lazy var textStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [self.labelUsername, self.labelEmail].forEach{ stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    lazy var rootStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [self.imageViewAvatar, self.textStack].forEach{ stackView.addArrangedSubview($0) }
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(rootStack)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout(){
        
       
        rootStack.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 3).isActive = true
        rootStack.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 2).isActive = true
        
        imageViewAvatar.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageViewAvatar.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func set(user: User){
        imageViewAvatar.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageViewAvatar.sd_setImage(with: URL(string: user.avatar!))
        labelEmail.text = user.email
        labelUsername.text = "\(user.firstName!) \(user.lastName!)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    
}
