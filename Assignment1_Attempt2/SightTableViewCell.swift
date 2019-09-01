//
//  PlaceTableViewCell.swift
//  Assignment1_Attempt2
//
//  Created by Shahrooq Pathan on 31/8/19.
//  Copyright © 2019 Shahrooq Pathan. All rights reserved.
//

import UIKit

class SightTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
