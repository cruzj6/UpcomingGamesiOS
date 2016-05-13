//
//  NewsArticleCell.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 5/13/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.
//

import UIKit

class NewsArticleCell: UITableViewCell {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
