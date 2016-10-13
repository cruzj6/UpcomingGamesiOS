//
//  GameMediaItem.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 5/14/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.
//

import Foundation

class GameMediaItem : NSObject{
    fileprivate var title : String!
    fileprivate var url : String!
    fileprivate var thumbnail : String!
    
    init(title: String, url: String, thumbnail: String)
    {
        self.title = title
        self.url = url
        self.thumbnail = thumbnail
    }
    
    func getTitle() -> String
    {
        return title
    }
    
    func getURL() -> String
    {
        return url
    }
    
    func getThumbnail() -> String
    {
        return thumbnail
    }
}
