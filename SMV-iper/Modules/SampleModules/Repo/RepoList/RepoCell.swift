//
//  RepoCell.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 10/3/18.
//  Copyright © 2018 Rifat Firdaus. All rights reserved.
//

import UIKit

class RepoCell: UITableViewCell {

    @IBOutlet private var labelName: UILabel!
    @IBOutlet private var labelUrl: UILabel!
    @IBOutlet private var labelDate: UILabel!
    
    var repo: Repo? {
        didSet {
            if let repo = repo {
                labelName.text = repo.name ?? " "
                labelUrl.text = repo.htmlUrl ?? " "
                labelDate.text = repo.updatedAt != nil ? (repo.updatedAt?.toColloquialString() ?? " ") : " "
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
