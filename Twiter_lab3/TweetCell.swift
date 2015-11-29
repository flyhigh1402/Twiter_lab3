//
//  TweetCell.swift
//  Twiter_lab3
//
//  Created by huy ngo on 11/26/15.
//  Copyright © 2015 huy ngo. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet var retweetedLabel: UILabel!
    @IBOutlet var screenNameLabel: UILabel!
    @IBOutlet var createdAtLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var textDescriptionLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    
    var tweet : Tweet! {
        didSet {
            nameLabel.text = tweet.user?.name
            createdAtLabel.text = tweet.createdAt?.toPrettyString()
            textDescriptionLabel.text = tweet.text
            screenNameLabel.text = "@\((tweet.user?.screenName)!)"
            let profileImageURL = NSURL(string: (tweet.user?.profileImageUrl)!)
            profileImageView.setImageWithURL(profileImageURL!)
            if tweet.retweet != nil {
                retweetedLabel.text = "\((tweet.retweet!.user?.screenName)!)retweeted"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profileImageView.layer.cornerRadius = 9.0
        self.profileImageView.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
