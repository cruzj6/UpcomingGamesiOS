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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        httpRequestManager.instance.getIsLoggedIn({(result: Bool) in
            
            self.isLoggedIn = result
            if(!self.isLoggedIn)
            {
                let urlRequest = URLRequest(url: URL(string: "http://upcominggames.herokuapp.com/auth/steam")!)
                _ = NSURLConnection(request: urlRequest, delegate: self)
                self.webView.loadRequest(urlRequest)
            }
            else{
                 self.goToTrackGames()
            }
        })

    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        let theCookieJar = HTTPCookieStorage.shared
        print("============Cookies=============")
        for cookie in theCookieJar.cookies!
        {
            print(cookie)
        }
        print("===========End Cookies==========")
        
        print("Loading: " + webView.request!.url!.absoluteString);
        if(webView.request!.url!.absoluteString.contains("https://upcominggames.herokuapp.com/"))
        {
            //Load the view, we logged in
            goToTrackGames()
            
            //Save cookies for the site
            let theCookieJarSite = HTTPCookieStorage.shared.cookies(for: URL(string: "https://upcominggames.herokuapp.com/")!)
            
            let userDefaults = UserDefaults.standard
            var cookieDict = [String : AnyObject]()

            for cookie in theCookieJarSite!
            {
               cookieDict[cookie.name] = cookie.properties as AnyObject?
            }
            
            userDefaults.set(cookieDict, forKey: "ucgames")

        }
        
    }
    
    func goToTrackGames()
    {
        if let mainContentController = storyboard?.instantiateViewController(withIdentifier: "mainContent")
        {
            present(mainContentController, animated: true, completion: nil)
        }
    }
    
    //Load stored cookies for the site
    func restoreCookies()
    {
        let cookiesStorage = HTTPCookieStorage.shared
        let userDefaults = UserDefaults.standard
        
        if let cookieDictionary = userDefaults.dictionary(forKey: "ucgames") {
            
            for (_, cookieProperties) in cookieDictionary {
                if let cookie = HTTPCookie(properties: cookieProperties as! [HTTPCookiePropertyKey : Any] ) {
                    cookiesStorage.setCookie(cookie)
                }
            }
        }

    }
    
    @IBAction func testClick(_ sender: AnyObject) {
        //restoreCookies()
    }
}
