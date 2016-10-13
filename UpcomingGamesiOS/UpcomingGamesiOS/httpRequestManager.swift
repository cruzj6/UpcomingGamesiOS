//
//  httpRequestManager.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 4/14/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.
//

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class httpRequestManager : NSObject{
    static let instance = httpRequestManager();
    var baseURL = "https://upcominggames.herokuapp.com";
    
    override init()
    {
        
    }
    
    func logUserIn(_ handleUserLoginFinished: () -> ())
    {
        //TODO: Auth
        //Callback login complete
        handleUserLoginFinished();
    }
    
    //Calls callback method passing it an array of NewsArticleItem's for the given game
    func requestArticlesForGame(_ gameName: String, handleGameArticles: @escaping ([NewsArticleItem]) -> ()){
        let reqString = baseURL + "/info/articles?gameName=" + gameName;
        let reqURL = URL(string: reqString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        let urlSession = URLSession.shared;
        
        let task = urlSession.dataTask(with: reqURL!, completionHandler: { (data:Data?, resp: URLResponse?, err: Error?) -> Void in
            
            do{
                //Serialize into JSON
                let newsArticlesData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            
                //newsData[] each contains title, date, desc, url
                var newsArticles = [NewsArticleItem]()
                for i in 0...((newsArticlesData as AnyObject).count - 1)
                {
                    //Parse the JSON data
                    let curArticleData = (newsArticlesData as AnyObject).object(at: i) as AnyObject
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
    
    func requestMediaForGame(_ gameName: String, handleGameMedia: @escaping ([GameMediaItem]) -> ())
    {
        let reqString = baseURL + "/info/gameMedia?gameName=" + gameName;
        let reqURL = URL(string: reqString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        let urlSession = URLSession.shared;
        
        let task = urlSession.dataTask(with: reqURL!, completionHandler: { (data:Data?, resp: URLResponse?, err: Error?) -> Void in
            
            do{
                //Serialize into JSON
                let gameMediaData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                
                var retData = [GameMediaItem]()
                
                for i in 0...((gameMediaData as AnyObject).count - 1)
                {
                    //Build GameMediaItem object
                    let curGameMediaItem = (gameMediaData as AnyObject).object(at: i) as AnyObject
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
    
    func buildUserTrackedGames(_ trackedGameDataHandler: @escaping ([TrackedGameItem]) -> ())
    {
        let reqString = baseURL + "/userdata/trackedGames";
        let reqURL = URL(string: reqString);
        let urlSession = URLSession.shared;
        
        let task = urlSession.dataTask(with: reqURL!, completionHandler: { (data:Data?, resp: URLResponse?, err: Error?) -> Void in
            
            //If no error getting data
            if(err == nil && data != nil){
                do{
                    //Get the JSON Data object
                    let trackedGamesDataUnsorted = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    print(trackedGamesDataUnsorted)
                    let returnItems = self.buildTrackedGamesItemsCollection(trackedGamesDataUnsorted as! NSArray)
                    
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
    
    func buildTrackedGamesItemsCollection(_ trackedGamesDataUnsorted: NSArray) -> [TrackedGameItem]
    {
        //Sort the game objects alphabetically
        let trackedGamesData = trackedGamesDataUnsorted.sorted{ (($0 as AnyObject)["name"] as! String) < (($1 as AnyObject)["name"] as! String)}
        
        //let trackedGamesData = trackedGamesDataUnsorted as! NSArray
        var returnItems = [TrackedGameItem]();
        
        //Convert the data into TrackedGameItem's
        for i in 0...(trackedGamesData.count - 1)
        {
            let curItem = trackedGamesData[i] as AnyObject
            let title = curItem["name"] as! String
            let imgurl = curItem["imageLink"] as! String
            let gbid = curItem["gbGameId"] as! NSNumber
            
            //First cast each release date item as an integer
            let releaseDay = curItem["releaseDay"] as? Int
            let releaseMonth = curItem["releaseMonth"] as? Int
            let releaseYear = curItem["releaseYear"] as? Int
            
            //Now
            let releaseMonthString = String(describing: releaseMonth).replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ")" ,with: "")
            let releaseDayString = String(describing: releaseDay).replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ")" ,with: "")
            let releaseYearString = String(describing: releaseYear).replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ")" ,with: "")
            let releaseDate = (releaseMonth >= 0 ? releaseMonthString + "/" : "")  + (releaseDay >= 0 ? releaseDayString + "/" : "") + (releaseYear >= 0 ? releaseYearString : "")
            let nextItem = TrackedGameItem(title: title, imgurl: imgurl, gbid: gbid as Int, releaseDate: (releaseDate == "" ? "TBA or Already Released" : releaseDate))
            
            returnItems.append(nextItem)
            
        }
        return returnItems
    }
    
    func getIsLoggedIn(_ handleLoginResult: @escaping (Bool)-> ())
    {
        
        let reqString = baseURL + "/auth/steam/isLoggedIn"
        let reqURL = URL(string: reqString)
        let urlSession = URLSession.shared
        
        let task = urlSession.dataTask(with: reqURL!, completionHandler: {(data:Data?, resp: URLResponse?, err: Error?) -> Void in
            
            do{
                //Get the JSON Data object
                let logInJSON = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
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
    
    func addGameToTracked(_ gameId: String)
    {
        //Set up our URL post request
        let reqString = baseURL + "/userdata/trackedGames"
        let reqURL = URL(string: reqString)
        let postParams = "gameid=" + gameId
        let urlSession = URLSession.shared
        var request = URLRequest(url: reqURL!)
        
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = postParams.data(using: String.Encoding.utf8)
        
        //Make the request
        let task = urlSession.dataTask(with: request)
        task.resume()
    }
    
    func removeGameFromTracked(_ gameId: String)
    {
        //Set up our URL post request
        //TODO: Change to delete
        let reqString = baseURL + "/userdata/trackedGames"
        let reqURL = URL(string: reqString)
        let postParams = "gameid=" + gameId
        let urlSession = URLSession.shared
        var request = URLRequest(url: reqURL!)
        
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = postParams.data(using: String.Encoding.utf8)
        
        //Make the request
        let task = urlSession.dataTask(with: request)
        task.resume()

    }
    
    func searchForGames(_ searchString: String, handleSearchResults: @escaping ([TrackedGameItem]) -> ())
    {
        let reqString = baseURL + "/info/searchGames?searchTerm=" + searchString.replacingOccurrences(of: "\t", with: " ")
        let reqURL = URL(string: reqString)
        let urlSession = URLSession.shared

        if(reqURL == nil)
        {
            //TODO: This means invalid search
            handleSearchResults([TrackedGameItem]())
            return
        }
        
        let task = urlSession.dataTask(with: reqURL!, completionHandler: { (data:Data?, resp: URLResponse?, err: Error?) -> Void in
            
            if(err == nil && data != nil){
                do{
                    //Get the JSON Data object
                    let searchResultsJSON = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    print(searchResultsJSON)
                
                    if((searchResultsJSON as AnyObject).count > 0){
                        let sortedResults = self.buildTrackedGamesItemsCollection(searchResultsJSON as! NSArray)
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
    
    func requestFriendsTracked(_ handleFriendsTracked: @escaping ([FriendsTrackedGamesItem]) -> ())
    {
        let reqString = baseURL + "/userdata/friendsTrackedGames";
        let reqURL = URL(string: reqString);
        let urlSession = URLSession.shared;
        
        let task = urlSession.dataTask(with: reqURL!, completionHandler: { (data:Data?, resp: URLResponse?, err: Error?) -> Void in
            
            //If no error getting data
            if(err == nil && data != nil){
                do{
                    //Get the JSON Data object
                    let friendsDataUnsorted = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    print(friendsDataUnsorted)
                    
                    //List to return
                    var friendsGameData = [FriendsTrackedGamesItem]();
                    
                    //For each user build their tracked games list
                    for data in friendsDataUnsorted as! NSArray
                    {
                        //Extract gamedata from JSON object
                        let trackedGames = (data as AnyObject)["gameData"] as? NSArray
                        let gameItems = (trackedGames?.count)! > 0 ? self.buildTrackedGamesItemsCollection(trackedGames! as NSArray) : [TrackedGameItem]()
                        
                        //Get username and avatar url from JSON
                        let userName = (data as AnyObject)["userid"] as! String
                        let avatarUrl = (data as AnyObject)["avatar"] as! String
                        
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
