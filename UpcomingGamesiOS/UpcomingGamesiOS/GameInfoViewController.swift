//
//  GameInfoViewController.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 5/11/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.
//

import UIKit

class GameInfoViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var segmentSelector: UISegmentedControl!
    @IBOutlet weak var pageDots: UIPageControl!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var gameInfoScrollView: UIScrollView!
    var curGameItem : TrackedGameItem?
    var scrollViewWidth : CGFloat?
    var scrollViewHeight : CGFloat?
    var newsViewController : NewsArticlesViewController!
    var mediaViewController : MediaViewController?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //Need to keep this strong so it doesn't get released
        newsViewController = NewsArticlesViewController(nibname: "NewsArticlesView", ownerVC: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameInfoScrollView.delegate = self
        //Set up the scroll view for paging
       // gameInfoScrollView.frame = CGRectMake(gameInfoScrollView.frame.minX, gameInfoScrollView.frame.minY, self.view.frame.width, gameInfoScrollView.frame.maxX - gameInfoScrollView.frame.minX);
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        gameInfoScrollView.contentSize = CGSize(width: gameInfoScrollView.frame.width * 2, height: gameInfoScrollView.frame.width)
         loadGameInfo();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setGameData(_ gameItem: TrackedGameItem)
    {
        curGameItem = gameItem;
    }
    
    fileprivate func loadGameInfo()
    {
        gameTitleLabel.text = curGameItem?.getTitle();
        
        //Make the URL secure to make request
        let unsecureURLString: String = (curGameItem?.getImgUrl())!;
        let secureURLString = unsecureURLString.replacingOccurrences(of: "http", with: "http", options: NSString.CompareOptions.literal, range: nil)
        
        //Create NSURL object for making the request
        let url = URL(string: secureURLString)
        
        //Make the request for the image and if we get data set it to image
        let data = try? Data(contentsOf: url!);
        if(data != nil){
            self.gameImageView.image = UIImage(data: data!)
        }
        
        //Get the News Articles for the game
        let reqManager = httpRequestManager.instance
        

        //Get the loading wheel going for news
        let loadingViewNews = UIActivityIndicatorView();
        loadingViewNews.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray;
        loadingViewNews.center = CGPoint(x: self.gameInfoScrollView.frame.width/2, y: self.gameInfoScrollView.frame.height/2)
        loadingViewNews.hidesWhenStopped = true;
        self.gameInfoScrollView.addSubview(loadingViewNews);
        loadingViewNews.startAnimating();
        
        reqManager.requestArticlesForGame((curGameItem?.getTitle())! ,
            handleGameArticles: {(newsItems: [NewsArticleItem]) in
                
                //On UI Thread
                DispatchQueue.main.async(execute: {
                    
                    //Add first page (news view)
                    self.newsViewController.view.frame = CGRect(x: 0, y: 0, width: self.gameInfoScrollView.frame.width, height: self.gameInfoScrollView.frame.height)
                    self.newsViewController.loadViewIfNeeded()
                    self.newsViewController.setNewsArts(newsItems)

                    loadingViewNews.stopAnimating();
                    
                    self.gameInfoScrollView.addSubview(self.newsViewController.view)
                })

        })
        
        //Get the loading wheel going for media
        let loadingViewMedia = UIActivityIndicatorView();
        loadingViewMedia.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray;
        loadingViewMedia.center = CGPoint(x: self.gameInfoScrollView.frame.width + self.gameInfoScrollView.frame.width/2, y: self.gameInfoScrollView.frame.height/2)
        loadingViewMedia.hidesWhenStopped = true;
        self.gameInfoScrollView.addSubview(loadingViewMedia);
        loadingViewMedia.startAnimating();

        reqManager.requestMediaForGame((curGameItem?.getTitle())!, handleGameMedia: {(mediaItems: [GameMediaItem]) in
            
            //ASync on UI Thread
            DispatchQueue.main.async(execute: {
                
                loadingViewMedia.stopAnimating()
                
                //Create VC from the nib
                self.mediaViewController = MediaViewController(nibName: "MediaView", mediaData: mediaItems)
                
                self.mediaViewController!.view.frame = CGRect(x: self.gameInfoScrollView.frame.width, y: 0, width: self.gameInfoScrollView.frame.width, height: self.gameInfoScrollView.frame.height)
                //self.mediaViewController!.loadViewIfNeeded()
                
                self.gameInfoScrollView.addSubview(self.mediaViewController!.view)
            })
        
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if(scrollView.contentOffset.x > scrollView.frame.width/2)
        {
            segmentSelector.selectedSegmentIndex = 1
            pageDots.currentPage = 1
        }
        else{
            segmentSelector.selectedSegmentIndex = 0
            pageDots.currentPage = 0
        }
    }
    
    @IBAction func sectionSelectionChanged(_ sender: AnyObject) {
        let selector = sender as! UISegmentedControl
        if(selector.selectedSegmentIndex == 1)
        {
            self.gameInfoScrollView.contentOffset.x = self.gameInfoScrollView.frame.width
        }
        else
        {
            self.gameInfoScrollView.contentOffset.x = 0
        }
    }
    
  }
