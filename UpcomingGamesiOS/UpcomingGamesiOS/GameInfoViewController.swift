//
//  GameInfoViewController.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 5/11/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.
//

import UIKit

class GameInfoViewController: UIViewController {
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var gameInfoScrollView: UIScrollView!
    var curGameItem : TrackedGameItem?
    var scrollViewWidth : CGFloat?
    var scrollViewHeight : CGFloat?
    
    //Need to keep this strong so it doesn't get released
    let newsViewController : NewsArticlesViewController = NewsArticlesViewController(nibname: "NewsArticlesView")
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up the scroll view for paging
        gameInfoScrollView.frame = CGRectMake(gameInfoScrollView.frame.minX, gameInfoScrollView.frame.minY, self.view.frame.width, gameInfoScrollView.frame.height);
        gameInfoScrollView.contentSize = CGSizeMake(gameInfoScrollView.frame.width * 2, gameInfoScrollView.frame.height)
        
        scrollViewWidth = gameInfoScrollView.frame.width
        scrollViewHeight = gameInfoScrollView.frame.height
        
        // Do any additional setup after loading the view.
        loadGameInfo();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setGameData(gameItem: TrackedGameItem)
    {
        curGameItem = gameItem;
    }
    
    private func loadGameInfo()
    {
        gameTitleLabel.text = curGameItem?.getTitle();
        
        //Make the URL secure to make request
        let unsecureURLString: String = (curGameItem?.getImgUrl())!;
        let secureURLString = unsecureURLString.stringByReplacingOccurrencesOfString("http", withString: "http", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        //Create NSURL object for making the request
        let url = NSURL(string: secureURLString)
        
        //Make the request for the image and if we get data set it to image
        let data = NSData(contentsOfURL: url!);
        if(data != nil){
            self.gameImageView.image = UIImage(data: data!)
        }
        
        //Get the News Articles for the game
        let reqManager = httpRequestManager.instance
        

        reqManager.requestArticlesForGame((curGameItem?.getTitle())! ,
            handleGameArticles: {(newsItems: [NewsArticleItem]) in
                
                //On UI Thread
                dispatch_async(dispatch_get_main_queue(),{
                    
                    //Add first page (news view)
                    self.newsViewController.view.frame = CGRectMake(0, 0, self.scrollViewWidth!, self.scrollViewHeight!)
                    self.newsViewController.loadViewIfNeeded()
                    self.newsViewController.setNewsArts(newsItems)

                    self.gameInfoScrollView.addSubview(self.newsViewController.view)
                })

        })
    }
    
  }
