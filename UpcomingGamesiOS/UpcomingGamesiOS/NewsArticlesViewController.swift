//
//  NewsArticlesView.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 5/12/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.
//

import UIKit

class NewsArticlesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var newsArtItems : [NewsArticleItem]!
    var ownerVC : UIViewController!
    
    init(nibname: String, ownerVC: UIViewController?)
    {
        super.init(nibName: nibname, bundle: nil);
        
        //Let this be nil, if it is the owner is itself
        self.ownerVC = (ownerVC == nil ? self : ownerVC)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "GameNewsArticleCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.rowHeight = tableView.dequeueReusableCell(withIdentifier: "Cell")!.frame.height
    }
    
    func setNewsArts(_ newsArts: [NewsArticleItem])
    {
      newsArtItems = newsArts
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(newsArtItems != nil)
        {
            return newsArtItems.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let theNewsItem = newsArtItems[(indexPath as NSIndexPath).row]
        let urlString = theNewsItem.getURLString()
        //urlString = urlString.stringByReplacingOccurrencesOfString("http", withString: "https")
        
        let webViewController = WebViewController(nibName: "WebURLView", bundle: nil)
        webViewController.setURLToLoad(urlString)
        
        let presentingVC : UIViewController! = ownerVC == nil ? self : ownerVC
        
        presentingVC.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        // Cover Vertical is necessary for CurrentContext
        presentingVC.modalPresentationStyle = .currentContext
        // Display on top of    current UIView
        presentingVC.present(webViewController, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //Get the new cell for the news article item
        let newCell:NewsArticleCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsArticleCell
        
        //Set the desc and the title
        newCell.titleLabel.text = newsArtItems[(indexPath as NSIndexPath).row].getTitle()
        newCell.descLabel.text = newsArtItems[(indexPath as NSIndexPath).row].getDescription()
        return newCell
    }

}
