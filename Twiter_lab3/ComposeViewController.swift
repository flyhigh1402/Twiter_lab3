//
//  ComposeViewController.swift
//  Twiter_lab3
//
//  Created by huy ngo on 11/27/15.
//  Copyright © 2015 huy ngo. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var screenNameLabel: UILabel!
    @IBOutlet var composeTextView: UITextView!
    @IBOutlet var characterCountDownLabel: UILabel!
    var Id : Int?
    var finalStatus = ""
    var tweet: Tweet?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        composeTextView.delegate = self
        nameLabel.text = User.currentUser?.name
        screenNameLabel.text = "@\((User.currentUser?.screenName)!)"
        let profileImageURL = NSURL(string: (User.currentUser?.profileImageUrl)!)
        profileImage.setImageWithURL(profileImageURL!)
        if tweet != nil {
            composeTextView.text = "@\((tweet?.user?.screenName)!)" + " "
            print(composeTextView.text)
            composeTextView.delegate?.textViewDidChange!(composeTextView)
            Id = tweet!.id
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onTweetButton(sender: AnyObject) {
        let status = composeTextView.text
        let params: NSDictionary = ["status": status]
        TwitterClient.sharedInstance.postNewStatusWithParams(status, Id: Id, params: params) { (status, error) -> () in
            if error != nil {
                print("Failed post status: \(error)")
            }
        NSNotificationCenter.defaultCenter().postNotificationName(self.finalStatus, object: status)
        self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        let length = composeTextView.text.characters.count
        let charReamining = 140 - length
        characterCountDownLabel.text = "\(charReamining)"
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let currentLength = composeTextView.text.characters.count
        let newLength = currentLength + text.characters.count - range.length
        if newLength > 140 {
            characterCountDownLabel.textColor = UIColor.redColor()
            return false
        } else {
            return true
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
