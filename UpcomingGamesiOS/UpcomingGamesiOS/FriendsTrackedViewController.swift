//
//  FriendsTrackedViewController.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 9/13/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.
//

import UIKit

class FriendsTrackedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var friendsTrackedGamesTable: UITableView!
    var showAll:Bool = false;
    var friendsTrackedGames : [FriendsTrackedGamesItem]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //default value for friendsTracked until we load
        friendsTrackedGames = [FriendsTrackedGamesItem]();
        
        loadFriendsTracked()

        // Do any additional setup after loading the view.
    }

    @IBAction func toggleShowAll(sender: AnyObject) {
        showAll = !showAll;
        let showTitle = showAll ? "Show All" : "Show with Tracked"
        sender.setTitle(showTitle, forState: .Normal);
    }
    
    private func loadFriendsTracked()
    {
        httpRequestManager.instance.requestFriendsTracked({(friendsTrackedItems: [FriendsTrackedGamesItem]) in
            
            //Update the table view on the UI thread
            dispatch_async(dispatch_get_main_queue(), {
            
                //Register the cell's nib with the table
                self.friendsTrackedGamesTable.registerNib(UINib(nibName: "FriendsTrackedCell", bundle: nil), forCellReuseIdentifier: "Cell")
            
                //Set the height of the cells
                self.friendsTrackedGamesTable.rowHeight = self.friendsTrackedGamesTable.dequeueReusableCellWithIdentifier("Cell")!.frame.height
                            
                //We got the data now reload the table with the data
                self.friendsTrackedGames = friendsTrackedItems
                self.friendsTrackedGamesTable.reloadData()
            });
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.friendsTrackedGames.count
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //TODO: Transition to their list of tracked games
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
       let cell = self.friendsTrackedGamesTable.dequeueReusableCellWithIdentifier("Cell") as! FriendsTrackedCell
        
        let item = friendsTrackedGames[indexPath.item]
        
        //Get name
        cell.friendNameLabel.text = item.getName()
        cell.numTrackedLabel.text = ( "" + String(item.getGameItems().count) + " tracked Games")
        
        //Get the avatar image async
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            //Make the URL secure to make request
            let unsecureURLString: String = item.getAvatarUrl()
            let secureURLString = unsecureURLString.stringByReplacingOccurrencesOfString("http", withString: "http", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            //Create NSURL object for making the request
            let url = NSURL(string: secureURLString)
            
            //Make the request for the image and if we get data set it to image
            let data = NSData(contentsOfURL: url!);
            
            dispatch_async(dispatch_get_main_queue()) {
                if(data != nil){
                    cell.avatarImg.image = UIImage(data: data!)
                }
            }
        }

        
        return cell;
    }

}
