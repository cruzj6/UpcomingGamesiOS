//
//  ServerLoginViewController.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 5/16/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.
//

import UIKit

class ServerLoginViewController: UIViewController, UIWebViewDelegate {

    

    @IBOutlet var webView: UIWebView!
    var isLoggedIn : Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self;
        
        restoreCookies()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        httpRequestManager.instance.getIsLoggedIn({(result: Bool) in
            
            self.isLoggedIn = result
            if(!self.isLoggedIn)
            {
                let urlRequest = NSURLRequest(URL: NSURL(string: "http://upcominggames.herokuapp.com/auth/steam")!)
                _ = NSURLConnection(request: urlRequest, delegate: self)
                self.webView.loadRequest(urlRequest)
            }
            else{
                 self.goToTrackGames()
            }
        })

    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        
        let theCookieJar = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        print("============Cookies=============")
        for cookie in theCookieJar.cookies!
        {
            print(cookie)
        }
        print("===========End Cookies==========")
        
        print("Loading: " + webView.request!.URL!.absoluteString);
        if(webView.request!.URL!.absoluteString == "https://upcominggames.herokuapp.com/")
        {
            //Load the view, we logged in
            goToTrackGames()
            
            //Save cookies for the site
            let theCookieJarSite = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookiesForURL(NSURL(string: "https://upcominggames.herokuapp.com/")!)
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            var cookieDict = [String : AnyObject]()

            for cookie in theCookieJarSite!
            {
               cookieDict[cookie.name] = cookie.properties
            }
            
            userDefaults.setObject(cookieDict, forKey: "ucgames")

        }
        
    }
    
    func goToTrackGames()
    {
        if let mainContentController = storyboard?.instantiateViewControllerWithIdentifier("mainContent")
        {
            presentViewController(mainContentController, animated: true, completion: nil)
        }
    }
    
    //Load stored cookies for the site
    func restoreCookies()
    {
        let cookiesStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let cookieDictionary = userDefaults.dictionaryForKey("ucgames") {
            
            for (_, cookieProperties) in cookieDictionary {
                if let cookie = NSHTTPCookie(properties: cookieProperties as! [String : AnyObject] ) {
                    cookiesStorage.setCookie(cookie)
                }
            }
        }

    }
    
    @IBAction func testClick(sender: AnyObject) {
        //restoreCookies()
    }
}
