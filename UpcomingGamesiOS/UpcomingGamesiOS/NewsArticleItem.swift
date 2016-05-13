//
//  NewsArticleItem.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 5/12/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.
//

import Foundation

class NewsArticleItem : NSObject{
    
    private var title : String
    private var desc : String
    private var urlString : String
    private var date : String
    
    init(title: String, desc: String, urlString: String, date: String)
    {
        self.title = title
        self.desc = desc
        self.urlString = urlString
        self.date = date
    }
    
    func getTitle() -> String{
        return self.title
    }
    
    func getDescription() -> String{
        return self.desc
    }
    
    func getURLString() -> String{
        return self.urlString
    }
    
    func getDate() -> String{
        return self.date
    }
}