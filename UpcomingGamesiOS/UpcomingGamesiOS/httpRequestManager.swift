//
//  httpRequestManager.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 4/14/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.
//

import Foundation

class httpRequestManager : NSObject{
    static let instance = httpRequestManager();
    var baseURL = "https://upcominggames.herokuapp.com";
    
    //TODO: Temporary user id, test with known until auth
    var userid = "76561198032119238";
    
    override init()
    {
        
    }
    
    func logUserIn(handleUserLoginFinished: () -> ())
    {
        //TODO: Auth
        //Callback login complete
        handleUserLoginFinished();
    }
    
    //Calls callback method passing it an array of NewsArticleItem's for the given game
    func requestArticlesForGame(gameName: String, handleGameArticles: ([NewsArticleItem]) -> ()){
        let reqString = baseURL + "/info/getArticles?gameName=" + gameName;
        let reqURL = NSURL(string: reqString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
        let urlSession = NSURLSession.sharedSession();
        
        let task = urlSession.dataTaskWithURL(reqURL!, completionHandler: { (data:NSData?, resp: NSURLResponse?, err: NSError?) -> Void in
            
            do{
                //Serialize into JSON
                let newsArticlesData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            
                //newsData[] each contains title, date, desc, url
                var newsArticles = [NewsArticleItem]()
                for i in 0...(newsArticlesData.count - 1)
                {
                    //Parse the JSON data
                    let curArticleData = newsArticlesData.objectAtIndex(i)
                    let title = curArticleData["title"] as! String
                    let urlString = curArticleData["url"] as! String
                    let desc = curArticleData["desc"] as! String
                    let date = curArticleData["date"] as! String
                    
                    //Build the next news article item
                    let articleItem = NewsArticleItem(title: title, desc: desc, urlString: urlString, date: date)
                    newsArticles.append(articleItem)
                }
                
                //Callback
                handleGameArticles(newsArticles)
            }
            catch{
                print("Error loading news articles data")
                handleGameArticles([NewsArticleItem]())
            }
        })
        
        task.resume();
    }
    
    func requestMediaForGame(gameName: String, handleGameMedia: ([GameMediaItem]) -> ())
    {
        let reqString = baseURL + "/info/gameMedia?gameName=" + gameName;
        let reqURL = NSURL(string: reqString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
        let urlSession = NSURLSession.sharedSession();
        
        let task = urlSession.dataTaskWithURL(reqURL!, completionHandler: { (data:NSData?, resp: NSURLResponse?, err: NSError?) -> Void in
            
            do{
                //Serialize into JSON
                let gameMediaData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                
                var retData = [GameMediaItem]()
                
                for i in 0...(gameMediaData.count - 1)
                {
                    //Build GameMediaItem object
                    let curGameMediaItem = gameMediaData.objectAtIndex(i)
                    let title : String = curGameMediaItem["title"] as! String
                    let url : String = curGameMediaItem["url"] as! String
                    //let thumbnail : String = curGameMediaItem["thumbnail"] as! String
                    
                    let newItem = GameMediaItem(title: title, url: url, thumbnail: "")
                    retData.append(newItem)
                }
                
                handleGameMedia(retData)

            }
            catch{
                //Just pass empty set
                handleGameMedia([GameMediaItem]())
            }
        })
        
        task.resume()
    }
    
    func buildUserTrackedGames(trackedGameDataHandler: ([TrackedGameItem]) -> ())
    {
        let reqString = baseURL + "/userdata/aUsersTrackedGames?id=" + userid;
        let reqURL = NSURL(string: reqString);
        let urlSession = NSURLSession.sharedSession();
        
        let task = urlSession.dataTaskWithURL(reqURL!, completionHandler: { (data:NSData?, resp: NSURLResponse?, err: NSError?) -> Void in
            
            //If no error getting data
            if(err == nil){
                do{
                    //Get the JSON Data object
                    let trackedGamesDataUnsorted = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    print(trackedGamesDataUnsorted)
                    
                    //Sort the game objects alphabetically
                    let trackedGamesData = (trackedGamesDataUnsorted as! NSArray).sort{ ($0["name"] as! String) < ($1["name"] as! String)}
                    
                    var returnItems = [TrackedGameItem]();
                    
                    //Convert the data into TrackedGameItem's
                    for i in 0...(trackedGamesData.count - 1)
                    {
                        let curItem = trackedGamesData[i];
                        let title = curItem["name"] as! String
                        let imgurl = curItem["imageLink"] as! String
                        let gbid = curItem["gbGameId"] as! NSNumber
                        
                        //First cast each release date item as an integer
                        let releaseDay = curItem["releaseDay"] as? Int
                        let releaseMonth = curItem["releaseMonth"] as? Int
                        let releaseYear = curItem["releaseYear"] as? Int
                        
                        //Now
                        let releaseMonthString = String(releaseMonth).stringByReplacingOccurrencesOfString("Optional(", withString: "").stringByReplacingOccurrencesOfString(")" ,withString: "")
                        let releaseDayString = String(releaseDay).stringByReplacingOccurrencesOfString("Optional(", withString: "").stringByReplacingOccurrencesOfString(")" ,withString: "")
                        let releaseYearString = String(releaseYear).stringByReplacingOccurrencesOfString("Optional(", withString: "").stringByReplacingOccurrencesOfString(")" ,withString: "")
                        let releaseDate = (releaseMonth >= 0 ? releaseMonthString + "/" : "")  + (releaseDay >= 0 ? releaseDayString + "/" : "") + (releaseYear >= 0 ? releaseYearString : "")
                        let nextItem = TrackedGameItem(title: title, imgurl: imgurl, gbid: gbid as Int, releaseDate: (releaseDate == "" ? "TBA or Already Released" : releaseDate))
                        
                        returnItems.append(nextItem)
                    }
                    
                    //Callback
                    trackedGameDataHandler(returnItems);
                }
                catch{
                    print("Error loading data")
                    trackedGameDataHandler([TrackedGameItem]());
                }
 
                }
            
        })
        
        task.resume();
    }
    
}