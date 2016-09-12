//
//  TrackedGameItem.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 4/14/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.
//

import UIKit

class TrackedGameItems: UIView{
    let userGameDataDel = UserTrackedGamesData();
    
    @IBOutlet weak var trackedGamesList: UICollectionView!
    
    func setUserTrackedGames(trackedGames: [TrackedGameItem])
    {
        //Set the data for the Grid view of each tracked game
        userGameDataDel.userTrackedGames = trackedGames;
        
        //Register the nib so it makes these
        trackedGamesList.registerNib(UINib(nibName: "TrackedGamesListItem", bundle: nil), forCellWithReuseIdentifier: "trackedCell")
        
        //Custom delegate and data source for cells and click events
        trackedGamesList.dataSource = userGameDataDel;
        trackedGamesList.delegate = userGameDataDel;
        
        //Long press on items
        let lp : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: userGameDataDel, action: #selector(userGameDataDel.handleLongPress))
        
        lp.minimumPressDuration = 0.5
        lp.delaysTouchesBegan = true
        lp.delegate = userGameDataDel
        
        self.trackedGamesList.addGestureRecognizer(lp)
        
        trackedGamesList.reloadData()
    }
    
}
