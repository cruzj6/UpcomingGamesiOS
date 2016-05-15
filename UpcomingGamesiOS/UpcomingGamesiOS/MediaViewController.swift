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
    
    init(nibName: String, mediaData: [GameMediaItem])
    {
        super.init(nibName: nibName, bundle: nil)
        
        //Pluck out the youtube media items from the collection
        var ytMediaItems : [GameMediaItem] = [GameMediaItem]()
        for i in 0...(mediaData.count - 1)
        {
            //Check if it is a youtube url, if so add it
            if(mediaData[i].getURL().containsString("youtube.com"))
            {
                ytMediaItems.append(mediaData[i])
            }
        }
        
        //Just the youtube videos for now
        self.mediaItems = ytMediaItems
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
        mediaScrollView.contentSize = CGSizeMake(mediaScrollView.frame.width, mediaScrollView.frame.height/2 * CGFloat(Double(mediaItems.count)))
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {

    }
    
    func loadMediaCells()
    {
        for i in 0...(mediaItems.count - 1)
        {
            //Create our cell for the media item
            let theCell : MediaViewCell = NSBundle.mainBundle().loadNibNamed("MediaViewCell", owner: self, options: nil).first as! MediaViewCell
        
            theCell.ytWebView.delegate = self
            
            //Build frame for the item, putting it next in the scroll view
            theCell.frame = CGRectMake(0, mediaScrollView.frame.height/2 * CGFloat(i), mediaScrollView.frame.width, mediaScrollView.frame.height/2)
        
            //Get the id and tite of the video
            //Get rid of everything in the URL except for the ID
            let videoId = mediaItems[i].getURL().stringByReplacingOccurrencesOfString("https://www.youtube.com/watch?v=", withString: "")
            let videoTitle = mediaItems[i].getTitle()
            theCell.videoTitleLabel.text = videoTitle
            
            //Set up the webView for showing the embedded youtube video
            theCell.ytWebView.scrollView.scrollEnabled = false
            theCell.ytWebView.allowsInlineMediaPlayback = true
            theCell.ytWebView.loadHTMLString("<iframe style=\"width: 100%\"src=\"https://www.youtube.com/embed/\(videoId)?&playsinline=1\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
            
            //Push it to the scroll view
            mediaScrollView.addSubview(theCell)
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {

    }
}
