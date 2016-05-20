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

class MediaViewController: UIViewController, UIWebViewDelegate, UIScrollViewDelegate {
    @IBOutlet var mediaScrollView: UIScrollView!
    var mediaItems : [GameMediaItem]!
    var numToShow : Int!
    
    init(nibName: String, mediaData: [GameMediaItem])
    {
        super.init(nibName: nibName, bundle: nil)
        
        //Pluck out the youtube media items from the collection
        var ytMediaItems : [GameMediaItem] = [GameMediaItem]()
        ytMediaItems = mediaData.filter{ $0.getURL().containsString("youtube.com") }
        
        //Just the youtube videos for now
        self.mediaItems = ytMediaItems
        self.numToShow = mediaItems.count > 10 ? 10 : mediaItems.count

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }
    
    override func viewDidAppear(animated: Bool) {
        mediaScrollView.contentSize = CGSizeMake(mediaScrollView.frame.width, mediaScrollView.frame.height/2 * CGFloat(numToShow))
        loadMediaCells()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {

    }
    
    func loadMediaCells()
    {
        for i in 0...(numToShow - 1)
        {
            //Create our cell for the media item
            let theCell : MediaViewCell = NSBundle.mainBundle().loadNibNamed("MediaViewCell", owner: self, options: nil).first as! MediaViewCell
        
            theCell.ytWebView.delegate = self
            
            //Get the id and tite of the video
            //Get rid of everything in the URL except for the ID
            let videoId = mediaItems[i].getURL().stringByReplacingOccurrencesOfString("https://www.youtube.com/watch?v=", withString: "")
            let videoTitle = mediaItems[i].getTitle()
            theCell.videoTitleLabel.text = videoTitle
            
            //Set up the webView for showing the embedded youtube video
            theCell.ytWebView.scrollView.scrollEnabled = false
            theCell.ytWebView.allowsInlineMediaPlayback = true
            theCell.ytWebView.loadHTMLString("<iframe src=\"https://www.youtube.com/embed/\(videoId)?&playsinline=1\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)

            //Build frame for the item, putting it next in the scroll view
            let frame = CGRectMake(0, mediaScrollView.frame.height/2 * CGFloat(i), mediaScrollView.frame.width, mediaScrollView.frame.height/2)
            theCell.frame = frame
        
            //Push it to the scroll view
            mediaScrollView.addSubview(theCell)
            mediaScrollView.didAddSubview(theCell)

        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {

    }
}
