//
//  UserDataManager.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 4/14/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.
//


import Foundation

class UserDataManager:NSObject{
    fileprivate var curTrackedGames : [TrackedGameItem]?
    static var instance = UserDataManager();
    
    var UserTrackedGames : [TrackedGameItem]{
        get{
            return curTrackedGames!;
        }
    }
    
    override init(){
        super.init();
    }
    
    func initializeUser(_ user: String, pass: String, handleUserInitFin: @escaping ()->())
    {
        //Log the user in to get the data
        httpRequestManager.instance.logUserIn({() in
    
            //Once logged in get the user's data from requests
            self.pullUserData({() in
                
                //Callback current user data has been pulled from server
                handleUserInitFin();
            });
        });
    }
    
    //Builds up the data for the user utilizing httpReqmanager
    fileprivate func pullUserData(_ handleDataPulled: @escaping ()->())
    {
        //Make request for user tracked games
        httpRequestManager.instance.buildUserTrackedGames ({ (trackedGames: [TrackedGameItem]) in
            self.curTrackedGames = trackedGames;
            
            //Callback, we loaded data
            handleDataPulled();
        })
    }

}
