//
//  Tweet.swift
//  iOS-W3-Assignment
//
//  Created by Van Do on 10/30/16.
//  Copyright © 2016 Van Do. All rights reserved.
//

import Foundation

class Tweet: NSObject {
    var text: String?
    var userName: String?
    var screenName: String?
    var timestamp: Date?
    var timeStampString: String?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var profileUrl: String?
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        userName = dictionary.value(forKeyPath: "user.name") as? String
        screenName = dictionary.value(forKeyPath: "user.screen_name") as? String
        profileUrl = dictionary.value(forKeyPath: "user.profile_image_url") as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        timeStampString = dictionary["created_at"] as? String
        let formatter = DateFormatter()
        
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        timestamp = formatter.date(from: timeStampString!) as Date?
        
        formatter.dateFormat = "d/M HH:mm"
        timeStampString = formatter.string(from: timestamp!)
    }
    
    class func tweetWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for item in dictionaries {
            let tweet = Tweet(dictionary: item)
            tweets.append(tweet)
        }
        
        return tweets
    }
}
