//
//  UserTrackedGamesData.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 4/14/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.
//

import UIKit

class UserTrackedGamesData : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    var userTrackedGames : [TrackedGameItem]!;
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let trackedGameCell: TrackedGamesListItemCell = collectionView
            .dequeueReusableCellWithReuseIdentifier("trackedCell", forIndexPath: indexPath) as! TrackedGamesListItemCell;
        
        let curGame = userTrackedGames[indexPath.item];
        
        //Make the URL secure to make request
        let unsecureURLString: String = curGame.getImgUrl();
        let secureURLString = unsecureURLString.stringByReplacingOccurrencesOfString("http", withString: "https", options: NSStringCompareOptions.LiteralSearch, range: nil)

        //Create NSURL object for making the request
        let url = NSURL(string: secureURLString)
        
        //TODO: hmm doesnt work
        //Make the request for the image and if we get data set it to image
        let data = NSData(contentsOfURL: url!);
        if(data != nil){
            trackedGameCell.gameImageView.image = UIImage(data: data!)
        }
        

        //Set the game title
        trackedGameCell.GameName = curGame.getTitle();
        
        return trackedGameCell;
    }
    
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userTrackedGames.count;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        //TODO: Spacing
        return CGSizeMake(UIScreen.mainScreen().bounds.width/2 - 50, collectionView.bounds.height/2);
    }

}
