//
//  UserTrackedGamesData.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 4/14/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.
//

import UIKit

class UserTrackedGamesData : NSObject, UICollectionViewDataSource, UICollectionViewDelegate
{
    override init()
    {
        super.init();
    }
    
    @objc func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    @objc func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
}
