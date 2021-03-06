//
//  User.swift
//  Twiter_lab3
//
//  Created by huy ngo on 11/26/15.
//  Copyright © 2015 huy ngo. All rights reserved.
//

import UIKit


var _currentUser: User?
let currentUserKey = "kCurrentUserkey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagLine: String?
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagLine = dictionary["description"] as? String
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as! NSData?
                if data != nil {
                    do {
                    let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                    } catch let error as NSError {
                        print("json error: \(error.localizedDescription)")
                    }
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                do {
                let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: []) 
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                } catch let error as NSError {
                    print("json error: \(error.localizedDescription)")
                }
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
