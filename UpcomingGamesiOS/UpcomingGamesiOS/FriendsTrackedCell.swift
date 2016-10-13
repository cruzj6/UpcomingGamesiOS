//
//  FriendsTrackedCell.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 9/18/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.
//

import UIKit

class FriendsTrackedCell: UITableViewCell {

    @IBOutlet var avatarImg: UIImageView!
    @IBOutlet var friendNameLabel: UILabel!
    @IBOutlet var numTrackedLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
