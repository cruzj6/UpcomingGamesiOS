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
    var navCtrl : UINavigationController!;
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let trackedGameCell: TrackedGamesListItemCell = collectionView
            .dequeueReusableCellWithReuseIdentifier("trackedCell", forIndexPath: indexPath) as! TrackedGamesListItemCell;
        
        trackedGameCell.layer.borderColor = UIColor.whiteColor().CGColor
        trackedGameCell.layer.borderWidth = 2.0
        
        let curGame = userTrackedGames[indexPath.item];
        
        //Get game image async
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            //Make the URL secure to make request
            let unsecureURLString: String = curGame.getImgUrl();
            let secureURLString = unsecureURLString.stringByReplacingOccurrencesOfString("http", withString: "http", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            //Create NSURL object for making the request
            let url = NSURL(string: secureURLString)
            
            //Make the request for the image and if we get data set it to image
            let data = NSData(contentsOfURL: url!);

            dispatch_async(dispatch_get_main_queue())
            {
                if(data != nil){
                    trackedGameCell.gameImageView.image = UIImage(data: data!)
                }
            }
        }
        
        
        //Set the game title
        trackedGameCell.GameName = curGame.getTitle();
        trackedGameCell.releaseDateLabel.text = curGame.getReleaseDate()

        return trackedGameCell;
    }
    
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userTrackedGames.count;
    }
    
    //Set the size of each cell
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSizeMake(collectionView.bounds.width/2, collectionView.bounds.height/4);
    }
    
    //Set the spacing
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0;
    }
    
    //On cell click
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        print("\"" + userTrackedGames[indexPath.item].getTitle() + "\"" + " selected");
        
        //Get the story board
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        //Create and get ref to the next view (Game Info)
        let gameViewController = storyboard.instantiateViewControllerWithIdentifier("gameInfoView") as! GameInfoViewController
        gameViewController.setGameData(userTrackedGames[indexPath.item])
        
        //Push the view in the navigation controller
        navCtrl.pushViewController(gameViewController, animated: true)
    }
    
    func setNavController(ctrl: UINavigationController)
    {
        //Set up nav controller for navigating when a game is selected
        self.navCtrl = ctrl;
    }

}
