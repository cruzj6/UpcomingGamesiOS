//
//  TrackedGamesListItemCell.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 4/22/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.
//

import UIKit

class TrackedGamesListItemCell: UICollectionViewCell {
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    
    var GameName : String{
        set{
            self.gameTitle.text = newValue;
        }
        get{
            return self.gameTitle.text!;
        }
    }
    
}
