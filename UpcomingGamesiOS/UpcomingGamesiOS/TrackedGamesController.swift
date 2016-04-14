//
//  FirstViewController.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 4/14/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.


import UIKit

class TrackedGamesController: UIViewController {

    @IBOutlet weak var userTrackedView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Load View for user tracked games, cast it
        let userGamesView = NSBundle.mainBundle().loadNibNamed("UserTrackedGames", owner: self, options: nil).last as! TrackedGameItems
        
        //Put the view into the view
        userTrackedView.addSubview(userGamesView);
        
        //TODO: log in stuffs
        //Initialize the user's data, and log them in
        UserDataManager.instance.initializeUser("TODO", pass: "TODO", handleUserInitFin: {() in
        
        });
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

