//
//  MediaViewController.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 5/14/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class MediaViewController: UIViewController, UIWebViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var mediaCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mediaCollectionView.registerNib(UINib(nibName: "MediaViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }
    
    override func viewDidAppear(animated: Bool) {
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.youtube.com/watch?v=hMmLWhSVUvY")!)

    }
    
    //Set the size of each cell
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSizeMake(mediaCollectionView.bounds.width, mediaCollectionView.bounds.height/2);
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let theCell : MediaViewCell = mediaCollectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! MediaViewCell
        
        theCell.ytWebView.delegate = self
        
        //TODO: PH
        let videoId = "Rg6GLVUnnpM"
        let videoTitle = "TESTING!!!"
        
        theCell.ytWebView.allowsInlineMediaPlayback = true
        theCell.ytWebView.loadHTMLString("<iframe width=\"\(theCell.ytWebView.frame.width)\" height=\"\(theCell.ytWebView.frame.height)\" src=\"https://www.youtube.com/embed/\(videoId)\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
        
        theCell.videoTitleLabel.text = videoTitle

        return theCell
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {

    }
}
