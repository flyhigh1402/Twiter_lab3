//
//  DetailViewController.swift
//  Twiter_lab3
//
//  Created by huy ngo on 11/27/15.
//  Copyright © 2015 huy ngo. All rights reserved.
//

import UIKit

protocol TweetsFeedDelegate {
    func userDidFavoriteTweet(tweet: Tweet, index: Int)
    func userDidRetweetTweet(tweet: Tweet, index: Int)
}

class DetailViewController: UIViewController {
    
    @IBOutlet var retweetedLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var screenNameLabel: UILabel!
    @IBOutlet var createdAtLabel: UILabel!
    @IBOutlet var textDescriptionLabel: UITextView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var numOfRetweetsLabel: UILabel!
    @IBOutlet var numOfFavLabel: UILabel!
    @IBOutlet var retweetButton: UIButton!
    @IBOutlet var favouriteButton: UIButton!
    var favourited: Bool!
    var retweeted: Bool!
    var tweet : Tweet!
    var delegate: TweetsFeedDelegate?
    var index: Int!
    
    let favoriteImage = UIImage(named: "favorited.png")
    let unfavoriteImage = UIImage(named: "unfavorite.png")
    let retweetedImage = UIImage(named: "retweeted.png")
    let retweetImage = UIImage(named: "retweet.png")

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewTweet(tweet)
        retweeted = tweet.retweeted
        setImageRetweetButton()
        favourited = tweet.favourited
        setImageFavButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setViewTweet(tweet: Tweet) {
        nameLabel.text = tweet.user?.name
        createdAtLabel.text = tweet.createdAtString
        textDescriptionLabel.text = tweet.text
        screenNameLabel.text = "@\((tweet.user?.screenName)!)"
        let profileImageURL = NSURL(string: (tweet.user?.profileImageUrl)!)
        profileImageView.setImageWithURL(profileImageURL!)
        profileImageView.layer.cornerRadius = 9.0
        profileImageView.layer.masksToBounds = true
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy 'at' h:mm aaa"
        createdAtLabel.text = formatter.stringFromDate(tweet.createdAt!)
        numOfFavLabel.text = "\(tweet.numOfFavorites!)"
        numOfRetweetsLabel.text = "\(tweet.numOfRetweets!)"
    }
    
    @IBAction func onRetweetButton(sender: AnyObject) {
        retweeted = !retweeted
        setImageRetweetButton(true)
    }

    @IBAction func onFavouriteButton(sender: AnyObject) {
        favourited = !favourited
        setImageFavButton(true)
    }

    @IBAction func onReplyButton(sender: AnyObject) {
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "replyTweet" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let composerViewController = navigationController.topViewController as! ComposeViewController
            composerViewController.tweet = self.tweet
        }
    }
    
    func setImageRetweetButton(toggle: Bool = false) {
        if retweeted! {
            retweetButton.setImage(retweetedImage, forState: .Normal)
            if toggle {
                TwitterClient.sharedInstance.retweetWithCompletion(tweet.id, completion: { (tweet, error) -> () in
                    if error == nil {
                        self.numOfRetweetsLabel.text = "\((self.tweet?.numOfRetweets)! + 1)"
                        tweet?.retweeted = true
                        self.delegate?.userDidRetweetTweet(tweet!, index: self.index)
                    } else {
                        print(error)
                        self.retweetButton.setImage(self.retweetImage, forState: .Normal)
                    }
                })
            }
        } else {
            retweetButton.setImage(retweetImage, forState: .Normal)
            if toggle {
                TwitterClient.sharedInstance.unRetweetWithCompletion(tweet.id, completion: { (tweet, error) -> () in
                    if error == nil {
                        self.numOfRetweetsLabel.text = "\((self.tweet?.numOfRetweets)!)"
                        tweet?.retweeted = false
                        self.delegate?.userDidFavoriteTweet(tweet!, index: self.index)
                    } else {
                        print(error)
                        self.retweetButton.setImage(self.retweetedImage, forState: .Normal)
                    }
                })
            }
        }
    }
    
    func setImageFavButton(toggle: Bool = false) {
        if favourited! {
            favouriteButton.setImage(favoriteImage, forState: .Normal)
            if toggle {
                TwitterClient.sharedInstance.favoriteWithCompletion(tweet.id, completion: { (tweet, error) -> () in
                    if error == nil {
                        self.numOfFavLabel.text = "\((self.tweet?.numOfFavorites)! + 1)"
                        tweet?.favourited = true
                        self.delegate?.userDidFavoriteTweet(tweet!, index: self.index)
                    } else {
                        print(error)
                        self.favouriteButton.setImage(self.unfavoriteImage, forState: .Normal)
                    }
                })
            }
        } else {
            favouriteButton.setImage(unfavoriteImage, forState: .Normal)
            if toggle {
                TwitterClient.sharedInstance.unFavoriteWithCompletion(tweet.id, completion: { (tweet, error) -> () in
                    if error == nil {
                        self.numOfFavLabel.text = "\((self.tweet?.numOfFavorites)!)"
                        tweet?.favourited = false
                        self.delegate?.userDidFavoriteTweet(tweet!, index: self.index)
                    } else {
                        print(error)
                        self.favouriteButton.setImage(self.favoriteImage, forState: .Normal)
                    }
                })
            }
        }
    }
}
