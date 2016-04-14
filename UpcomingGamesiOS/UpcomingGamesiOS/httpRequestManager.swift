//
//  httpRequestManager.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 4/14/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.
//

import Foundation

class httpRequestManager : NSObject{
    static let instance = httpRequestManager();
    var baseURL = "https://upcominggames.herokuapp.com";
    
    //TODO: Temporary user id, test with knows until auth
    var userid = "76561198032119238";
    
    override init()
    {
        
    }
    
    func logUserIn(handleUserLoginFinished: () -> ())
    {
        //TODO: Auth
        //Callback login complete
        handleUserLoginFinished();
    }
    
    func buildUserTrackedGames(trackedGameDataHandler: ([TrackedGameItem]) -> ())
    {
        let reqString = baseURL + "/userdata/aUsersTrackedGames?id=" + userid;
        let reqURL = NSURL(string: reqString);
        let urlSession = NSURLSession.sharedSession();
        
        let task = urlSession.dataTaskWithURL(reqURL!, completionHandler: { (data:NSData?, resp: NSURLResponse?, err: NSError?) -> Void in
            
            //If no error getting data
            if(err == nil){
                do{
                    //Get the JSON Data object
                    let trackedGamesData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    print(trackedGamesData)
                    
                    var returnItems = [TrackedGameItem]();
                    
                    //Convert the data into TrackedGameItem's
                    for i in 0...(trackedGamesData.count - 1)
                    {
                        let curItem = trackedGamesData.objectAtIndex(i);
                        let title = curItem["name"] as! String
                        let imgurl = curItem["imageLink"] as! String
                        let gbid = Int(curItem["gbGameId"] as! String)
                        let nextItem = TrackedGameItem(title: title, imgurl: imgurl, gbid: gbid!, releaseDate: "")
                        
                        returnItems.append(nextItem)
                    }
                    
                    //Callback
                    trackedGameDataHandler(returnItems);
                }
                catch{
                    print("Error loading data")
                    trackedGameDataHandler([TrackedGameItem]());
                }
 
                }
            
        })
        
        task.resume();
    }
    
}