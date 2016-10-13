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

    @IBAction func toggleShowAll(_ sender: AnyObject) {
        showAll = !showAll;
        let showTitle = showAll ? "Show All" : "Show with Tracked"
        sender.setTitle(showTitle, for: UIControlState());
    }
    
    fileprivate func loadFriendsTracked()
    {
        httpRequestManager.instance.requestFriendsTracked({(friendsTrackedItems: [FriendsTrackedGamesItem]) in
            
            //Update the table view on the UI thread
            DispatchQueue.main.async(execute: {
            
                //Register the cell's nib with the table
                self.friendsTrackedGamesTable.register(UINib(nibName: "FriendsTrackedCell", bundle: nil), forCellReuseIdentifier: "Cell")
            
                //Set the height of the cells
                self.friendsTrackedGamesTable.rowHeight = self.friendsTrackedGamesTable.dequeueReusableCell(withIdentifier: "Cell")!.frame.height
                            
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.friendsTrackedGames.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //TODO: Transition to their list of tracked games
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       let cell = self.friendsTrackedGamesTable.dequeueReusableCell(withIdentifier: "Cell") as! FriendsTrackedCell
        
        let item = friendsTrackedGames[(indexPath as NSIndexPath).item]
        
        //Get name
        cell.friendNameLabel.text = item.getName()
        cell.numTrackedLabel.text = ( "" + String(item.getGameItems().count) + " tracked Games")
        
        //Get the avatar image async
        let priority = DispatchQueue.GlobalQueuePriority.default
        DispatchQueue.global(priority: priority).async {
            
            //Make the URL secure to make request
            let unsecureURLString: String = item.getAvatarUrl()
            let secureURLString = unsecureURLString.replacingOccurrences(of: "http", with: "http", options: NSString.CompareOptions.literal, range: nil)
            
            //Create NSURL object for making the request
            let url = URL(string: secureURLString)
            
            //Make the request for the image and if we get data set it to image
            let data = try? Data(contentsOf: url!);
            
            DispatchQueue.main.async {
                if(data != nil){
                    cell.avatarImg.image = UIImage(data: data!)
                }
            }
        }

        
        return cell;
    }

}
