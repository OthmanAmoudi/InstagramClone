//
//  TableViewCell.swift
//  InstagramClone
//
//  Created by Othman Mashaab on 21/05/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var ppContainer2: UIImageView!
    @IBOutlet weak var nameLabel2: UILabel!
    @IBOutlet weak var captionLabel2: UILabel!
    @IBOutlet weak var postContainer2: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
