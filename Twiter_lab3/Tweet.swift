//
//  Tweet.swift
//  Twiter_lab3
//
//  Created by huy ngo on 11/26/15.
//  Copyright © 2015 huy ngo. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var retweet: Tweet?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var numOfRetweets: Int?
    var numOfFavorites: Int?
    var id: Int
    var id_str : String
    var favourited: Bool
    var retweeted: Bool
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        let retweetStatus = dictionary["retweeted_status"] as? NSDictionary
        if retweetStatus != nil {
            self.retweet = Tweet(dictionary: retweetStatus!)
        }
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        numOfRetweets = dictionary["retweet_count"] as? Int
        numOfFavorites = dictionary["favorite_count"]as? Int
        id = dictionary["id"] as! Int
        id_str = dictionary["id_str"] as! String
        favourited = dictionary["favorited"] as! Bool
        retweeted = dictionary["retweeted"] as! Bool
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
}
