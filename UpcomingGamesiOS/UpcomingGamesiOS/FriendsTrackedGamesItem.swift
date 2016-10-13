//
//  FriendsTrackedGamesItem.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 9/14/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.
//

import UIKit

class FriendsTrackedGamesItem: NSObject {
    
    fileprivate var name : String!
    fileprivate var gameItems : [TrackedGameItem]!
    fileprivate var avatarUrl : String!

    init(name: String, gameItems: [TrackedGameItem], avatarUrl: String)
    {
        self.name = name
        self.gameItems = gameItems
        self.avatarUrl = avatarUrl
    }
    
    internal func getName() -> String
    {
        return name
    }
    
    internal func getGameItems() -> [TrackedGameItem]
    {
        return gameItems
    }
    
    internal func getAvatarUrl() -> String
    {
        return avatarUrl
    }
}
