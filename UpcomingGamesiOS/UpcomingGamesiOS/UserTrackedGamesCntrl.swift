//
//  UserTrackedGamesData.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 4/14/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.
//

import UIKit

class UserTrackedGamesData : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate
{
    var userTrackedGames : [TrackedGameItem]!;
    var navCtrl : UINavigationController!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
    }
    
    func handleLongPress(_ sender: UILongPressGestureRecognizer)
    {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let trackedGameCell: TrackedGamesListItemCell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "trackedCell", for: indexPath) as! TrackedGamesListItemCell;
        
        trackedGameCell.layer.borderColor = UIColor.white.cgColor
        trackedGameCell.layer.borderWidth = 2.0
        
        let curGame = userTrackedGames[(indexPath as NSIndexPath).item];
        
        //Get game image async
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async{
            //Make the URL secure to make request
            let unsecureURLString: String = curGame.getImgUrl();
            let secureURLString = unsecureURLString.replacingOccurrences(of: "http", with: "http", options: NSString.CompareOptions.literal, range: nil)
            
            //Create NSURL object for making the request
            let url = URL(string: secureURLString)
            
            //Make the request for the image and if we get data set it to image
            let data = try? Data(contentsOf: url!);

            DispatchQueue.main.async
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
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userTrackedGames.count;
    }
    
    //Set the size of each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: collectionView.bounds.width/2, height: collectionView.bounds.height/4);
    }
    
    //Set the spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0;
    }
    
    //On cell click
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        print("\"" + userTrackedGames[(indexPath as NSIndexPath).item].getTitle() + "\"" + " selected");
        
        //Get the story board
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        //Create and get ref to the next view (Game Info)
        let gameViewController = storyboard.instantiateViewController(withIdentifier: "gameInfoView") as! GameInfoViewController
        gameViewController.setGameData(userTrackedGames[(indexPath as NSIndexPath).item])
        
        //Push the view in the navigation controller
        navCtrl.pushViewController(gameViewController, animated: true)
    }
    
    func setNavController(_ ctrl: UINavigationController)
    {
        //Set up nav controller for navigating when a game is selected
        self.navCtrl = ctrl;
    }

}
