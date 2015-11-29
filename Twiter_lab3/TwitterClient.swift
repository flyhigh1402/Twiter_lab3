//
//  TwitterClient.swift
//  Twiter_lab3
//
//  Created by huy ngo on 11/26/15.
//  Copyright © 2015 huy ngo. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "YjKN0WNkXAqbPjhQ0dnVfgJfa"
let twitterConsumerSecret = "Lo2reYwTh9LAX5cciw6nSqEFyM5ViZjM4Fi3qUYOF9ZWwYLNy0"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion:(tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
            //print("home timeline: \(response)")
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                print("error: \(error)")
                completion(tweets: nil, error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        //fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken :BDBOAuth1Credential!) -> Void in
            print("Got the request Token")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
        }) { (error: NSError!) -> Void in
            print("Failed to get request Token")
            self.loginCompletion?(user: nil, error: error)
        }

    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Accessed")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
                //print("user: \(response)")
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
               // print("user: \(user.name)")
                self.loginCompletion?(user: user, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                print("error: \(error)")
                self.loginCompletion?(user: nil, error: error)
            })
        }) { (error: NSError!) -> Void in
            print("Failed")
        }
    }
    
    func postNewStatusWithParams(tweet: String, Id: Int?, params: NSDictionary?, completion:(status: Tweet?, error: NSError?) -> ()) {
        var params = ["status": tweet]
        if Id != nil {
            params["in_reply_to_status_id"] = String(Id)
        }
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
            let status = Tweet(dictionary: response as! NSDictionary)
            completion(status: status, error: nil)
        }, failure: { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
            print("failled posting status: \(error)")
            completion(status: nil, error: error)
        })
    }
    
    func retweetWithCompletion(tweetId: Int, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("/1.1/statuses/retweet/\(tweetId).json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }, failure: { (operation:AFHTTPRequestOperation?, error: NSError!) -> Void in
                print("Fail to retweet: \(error)")
                completion(tweet: nil, error: error)
        })
    }
    
    func unRetweetWithCompletion(tweetId: Int, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("/1.1/statuses/destroy/\(tweetId).json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }, failure: { (operation:AFHTTPRequestOperation?, error: NSError!) -> Void in
                print("Fail to untweet: \(error)")
                completion(tweet: nil, error: error)
        })
    }

    func favoriteWithCompletion(tweetId: Int, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        let params = ["id": tweetId]
        POST("/1.1/favorites/create.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            
            }, failure: { (operation:AFHTTPRequestOperation?, error: NSError!) -> Void in
                print(error)
                completion(tweet: nil, error: error)
        })
    }
    
    func unFavoriteWithCompletion(tweetId: Int, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        let params = ["id": tweetId]
        POST("1.1/favorites/destroy.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            
            }, failure: { (operation:AFHTTPRequestOperation?, error: NSError!) -> Void in
                print(error)
                completion(tweet: nil, error: error)
        })
    }


}
