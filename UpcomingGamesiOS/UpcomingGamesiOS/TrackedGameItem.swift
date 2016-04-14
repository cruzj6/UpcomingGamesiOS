//
//  TrackedGameItem.swift
//  UpcomingGamesiOS
//
//  Created by Joseph Cruz on 4/14/16.
//  Copyright © 2016 Joseph Cruz. All rights reserved.
//

import Foundation

class TrackedGameItem : NSObject{
    private var title: String;
    private var imgurl: String;
    private var gbid: Int;
    private var releasedate: String;
    
    init(title: String, imgurl: String, gbid: Int, releaseDate: String){
        self.title = title
        self.imgurl = imgurl
        self.gbid = gbid
        self.releasedate = releaseDate
    }
    
    func getTitle() -> String{
        return self.title;
    }
    
    func getImgUrl() -> String{
        return imgurl;
    }
    
    func getgbid() -> Int{
        return gbid;
    }
    
    func getReleaseDate() -> String{
        return releasedate
    }
}
