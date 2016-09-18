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
        let reqString = baseURL + "/info/articles?gameName=" + gameName;
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
        let reqString = baseURL + "/userdata/trackedGames";
        let reqURL = NSURL(string: reqString);
        let urlSession = NSURLSession.sharedSession();
        
        let task = urlSession.dataTaskWithURL(reqURL!, completionHandler: { (data:NSData?, resp: NSURLResponse?, err: NSError?) -> Void in
            
            //If no error getting data
            if(err == nil && data != nil){
                do{
                    //Get the JSON Data object
                    let trackedGamesDataUnsorted = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    print(trackedGamesDataUnsorted)
                    let returnItems = self.buildTrackedGamesItemsCollection(trackedGamesDataUnsorted)
                    
                    //Callback
                    trackedGameDataHandler(returnItems);
                }
                catch
                {
                    print("Error loading data")
                    trackedGameDataHandler([TrackedGameItem]());
                }
            }
        })
        
        task.resume();
    }
    
    func buildTrackedGamesItemsCollection(trackedGamesDataUnsorted: AnyObject) -> [TrackedGameItem]
    {
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
        return returnItems
    }
    
    func getIsLoggedIn(handleLoginResult: (Bool)-> ())
    {
        
        let reqString = baseURL + "/auth/steam/isLoggedIn"
        let reqURL = NSURL(string: reqString)
        let urlSession = NSURLSession.sharedSession()
        
        let task = urlSession.dataTaskWithURL(reqURL!, completionHandler: { (data:NSData?, resp: NSURLResponse?, err: NSError?) -> Void in
            
            do{
                //Get the JSON Data object
                let logInJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                //let firstItem = logInJSON.objectAtIndex(0)
                let result = logInJSON["isIn"] as! Bool
                handleLoginResult(result)
            }
            catch{
                print("login check failed")
            }

        })
        
        task.resume()
    }
    
    func addGameToTracked(gameId: String)
    {
        //Set up our URL post request
        let reqString = baseURL + "/userdata/trackedGames"
        let reqURL = NSURL(string: reqString)
        let postParams = "gameid=" + gameId
        let urlSession = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: reqURL!)
        
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postParams.dataUsingEncoding(NSUTF8StringEncoding)
        
        //Make the request
        let task = urlSession.dataTaskWithRequest(request)
        task.resume()
    }
    
    func removeGameFromTracked(gameId: String)
    {
        //Set up our URL post request
        //TODO: Change to delete
        let reqString = baseURL + "/userdata/trackedGames"
        let reqURL = NSURL(string: reqString)
        let postParams = "gameid=" + gameId
        let urlSession = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: reqURL!)
        
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postParams.dataUsingEncoding(NSUTF8StringEncoding)
        
        //Make the request
        let task = urlSession.dataTaskWithRequest(request)
        task.resume()

    }
    
    func searchForGames(searchString: String, handleSearchResults: ([TrackedGameItem]) -> ())
    {
        let reqString = baseURL + "/info/searchGames?searchTerm=" + searchString.stringByReplacingOccurrencesOfString("\t", withString: " ")
        let reqURL = NSURL(string: reqString)
        let urlSession = NSURLSession.sharedSession()

        if(reqURL == nil)
        {
            //TODO: This means invalid search
            handleSearchResults([TrackedGameItem]())
            return
        }
        
        let task = urlSession.dataTaskWithURL(reqURL!, completionHandler: { (data:NSData?, resp: NSURLResponse?, err: NSError?) -> Void in
            
            if(err == nil && data != nil){
                do{
                    //Get the JSON Data object
                    let searchResultsJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    print(searchResultsJSON)
                
                    if(searchResultsJSON.count > 0){
                        let sortedResults = self.buildTrackedGamesItemsCollection(searchResultsJSON)
                        handleSearchResults(sortedResults)
                    }
                    
                }
                catch
                {
                    print("ERROR: Server or Search Error")
                    handleSearchResults([TrackedGameItem]())
                }
            }
            else
            {
                handleSearchResults([TrackedGameItem]())
            }

        })
        
        if(reqURL != nil){
            task.resume()
        }
        else{
           handleSearchResults([TrackedGameItem]())
        }
    }
    
    func requestFriendsTracked(handleFriendsTracked: ([FriendsTrackedGamesItem]) -> ())
    {
        let reqString = baseURL + "/userdata/friendsTrackedGames";
        let reqURL = NSURL(string: reqString);
        let urlSession = NSURLSession.sharedSession();
        
        let task = urlSession.dataTaskWithURL(reqURL!, completionHandler: { (data:NSData?, resp: NSURLResponse?, err: NSError?) -> Void in
            
            //If no error getting data
            if(err == nil && data != nil){
                do{
                    //Get the JSON Data object
                    let friendsDataUnsorted = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    print(friendsDataUnsorted)
                    
                    //List to return
                    var friendsGameData = [FriendsTrackedGamesItem]();
                    
                    //For each user build their tracked games list
                    for data in friendsDataUnsorted as! NSArray
                    {
                        //Extract gamedata from JSON object
                        let trackedGames = data["gameData"] as! NSArray
                        let gameItems = trackedGames.count > 0 ? self.buildTrackedGamesItemsCollection(trackedGames as AnyObject) : [TrackedGameItem]()
                        
                        //Get username and avatar url from JSON
                        let userName = data["userid"] as! String
                        let avatarUrl = data["avatar"] as! String
                        
                        //Push new item into list
                        friendsGameData.append(FriendsTrackedGamesItem(name: userName, gameItems: gameItems, avatarUrl: avatarUrl))
                    }
                    
                    //Callback to caller handler
                    handleFriendsTracked(friendsGameData);
                }
                catch
                {
                    print("Error loading data")
                    
                    //return empty array on error
                    handleFriendsTracked([FriendsTrackedGamesItem]())
                }
            }
        })
        
        task.resume();
    }
    
}