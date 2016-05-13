//
//  FirstViewController.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 4/14/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.


import UIKit

class TrackedGamesController: UIViewController {
    var viewFrame : CGRect!//View minus the nav bar
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view, typically from a nib
        //Load View for user tracked games, cast it
        let userGamesView = NSBundle.mainBundle().loadNibNamed("TrackedGameView", owner: self, options: nil).last as! TrackedGameItems
        userGamesView.userGameDataDel.setNavController(navigationController!);
        
        //Get our viewFrame
        viewFrame = CGRectMake(self.view.frame.minX, self.view.frame.minY + self.navigationController!.navigationBar.frame.size.height + 20, self.view.frame.width, self.view.frame.height - self.navigationController!.navigationBar.frame.size.height - 20);
        
        //Get the loading wheel going
        let loadingView = UIActivityIndicatorView();
        loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray;
        loadingView.center = self.view.center;
        loadingView.hidesWhenStopped = true;
        self.view.addSubview(loadingView);
        loadingView.startAnimating();
        
        //TODO: log in stuffs
        //Initialize the user's data, and log them in
        UserDataManager.instance.initializeUser("TODO", pass: "TODO", handleUserInitFin: {() in
        
            //On UI Thread
            dispatch_async(dispatch_get_main_queue(),{
                //Stop loading wheel
                loadingView.stopAnimating();
                userGamesView.setUserTrackedGames(UserDataManager.instance.UserTrackedGames);
                
                userGamesView.frame = self.viewFrame
                
                //Put the view into the view
                self.view.addSubview(userGamesView);
            });
        });
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

