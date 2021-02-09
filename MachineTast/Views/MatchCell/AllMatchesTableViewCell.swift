//
//  AllMatchesTableViewCell.swift
//  MachineTast
//
//  Created by Nilesh Gadhe on 03/02/21.
//  Copyright © 2021 Demo. All rights reserved.
//

import UIKit

class AllMatchesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblMatchName: UILabel!
    @IBOutlet weak var lblMatchId: UILabel!
    @IBOutlet weak var imageViewStar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
