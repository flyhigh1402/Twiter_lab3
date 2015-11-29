//
//  TweetViewController.swift
//  Twiter_lab3
//
//  Created by huy ngo on 11/26/15.
//  Copyright © 2015 huy ngo. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetsFeedDelegate {
    
    var tweets: [Tweet]!
    var status = ""
    @IBOutlet var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserverForName(status, object: nil, queue: nil) { (notification: NSNotification!) -> Void in
            let status = notification.object as! Tweet
            self.tweets.insert(status, atIndex: 0)
            self.tableView.reloadData()
        }
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 0, blue: 30, alpha: 0.5)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl.addTarget(self, action: Selector("homeTimelineWithParams"), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        homeTimelineWithParams()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
        return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tweet = tweets![indexPath.row]
        if tweet.retweet == nil {
            let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as! TweetCell
            cell.tweet = tweets[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("retweetCell", forIndexPath: indexPath) as! TweetCell
            cell.tweet = tweet
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func homeTimelineWithParams() {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func userDidFavoriteTweet(tweet: Tweet, index: Int) {
        tweets[index] = tweet
        tableView.reloadData()
    }
    
    func userDidRetweetTweet(tweet: Tweet, index: Int) {
        tweets[index] = tweet
        tableView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newTweetView" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let composeViewController = navigationController.topViewController as! ComposeViewController
        }
        if segue.identifier == "detailView" {
            let detailViewController = segue.destinationViewController as! DetailViewController
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)!
            detailViewController.tweet = tweets[indexPath.row]
            detailViewController.delegate = self
            detailViewController.index = indexPath.row
        }
    }
}

