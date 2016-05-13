//
//  WebViewController.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 5/13/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, NSURLConnectionDelegate {


    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var webView: UIWebView!
    var urlToLoad : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if(urlToLoad != nil)
        {
            let urlRequest = NSURLRequest(URL: NSURL(string: (urlToLoad)!)!)
            let urlConnection = NSURLConnection(request: urlRequest, delegate: self)
            webView.loadRequest(urlRequest)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func connection(connection: NSURLConnection, canAuthenticateAgainstProtectionSpace protectionSpace: NSURLProtectionSpace) -> Bool{
        return true
    }
    
    
    func connection(connection: NSURLConnection, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge){
        
        print("did autherntcationchallenge = \(challenge.protectionSpace.authenticationMethod)")
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust  {
            print("send credential Server Trust")
            let credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
            challenge.sender!.useCredential(credential, forAuthenticationChallenge: challenge)
            
        }else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodHTTPBasic{
            print("send credential HTTP Basic")
            let defaultCredentials: NSURLCredential = NSURLCredential(user: "username", password: "password", persistence:NSURLCredentialPersistence.ForSession)
            challenge.sender!.useCredential(defaultCredentials, forAuthenticationChallenge: challenge)
            
        }else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodNTLM{
            print("send credential NTLM")
            
        } else{
            challenge.sender!.performDefaultHandlingForAuthenticationChallenge!(challenge)
        }
    }
    
    func setURLToLoad(url: String)
    {
        if(self.isViewLoaded())
        {
            webView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
        }
        else{
            urlToLoad = url
        }
    }
    
    @IBAction func closeClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
