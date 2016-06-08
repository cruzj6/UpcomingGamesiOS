//
//  SearchGameCell.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 6/8/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.
//

import UIKit

class SearchGameCell: UITableViewCell {

    @IBOutlet var gameImageView: UIImageView!
    @IBOutlet var addToTrackedButton: UIButton!
    @IBOutlet var gameNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
