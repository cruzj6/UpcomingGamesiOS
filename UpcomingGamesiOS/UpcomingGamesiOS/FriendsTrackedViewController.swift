//
//  FriendsTrackedViewController.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 9/13/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.
//

import UIKit

class FriendsTrackedViewController: UIViewController {
    
    var showAll:Bool = false;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }

    @IBAction func toggleShowAll(sender: AnyObject) {
        showAll = !showAll;
        let showTitle = showAll ? "Show All" : "Show with Tracked"
        sender.setTitle(showTitle, forState: .Normal);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
