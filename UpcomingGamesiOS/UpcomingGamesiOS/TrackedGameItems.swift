//
//  TrackedGameItem.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 4/14/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.
//

import UIKit

class TrackedGameItems: UIView{
    @IBOutlet weak var trackedGamesList: UICollectionView!
    
    func setUserTrackedGames()
    {
        let userGameDataDel = UserTrackedGamesData();
        trackedGamesList.delegate = userGameDataDel;
        trackedGamesList.dataSource = userGameDataDel;
    }
    
}
