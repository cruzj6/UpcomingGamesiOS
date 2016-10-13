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
            let urlRequest = URLRequest(url: URL(string: (urlToLoad)!)!)
            _ = NSURLConnection(request: urlRequest, delegate: self)
            webView.loadRequest(urlRequest)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func connection(_ connection: NSURLConnection, canAuthenticateAgainstProtectionSpace protectionSpace: URLProtectionSpace) -> Bool{
        return true
    }
    
    
    func connection(_ connection: NSURLConnection, didReceive challenge: URLAuthenticationChallenge){
        
        print("did autherntcationchallenge = \(challenge.protectionSpace.authenticationMethod)")
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust  {
            print("send credential Server Trust")
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            challenge.sender!.use(credential, for: challenge)
            
        }else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodHTTPBasic{
            print("send credential HTTP Basic")
            let defaultCredentials: URLCredential = URLCredential(user: "username", password: "password", persistence:URLCredential.Persistence.forSession)
            challenge.sender!.use(defaultCredentials, for: challenge)
            
        }else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodNTLM{
            print("send credential NTLM")
            
        } else{
            challenge.sender!.performDefaultHandling!(for: challenge)
        }
    }
    
    func setURLToLoad(_ url: String)
    {
        if(self.isViewLoaded)
        {
            webView.loadRequest(URLRequest(url: URL(string: url)!))
        }
        else{
            urlToLoad = url
        }
    }
    
    @IBAction func closeClick(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
