//
//  postCell.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/26/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse

class postCell: UITableViewCell {
    
    // theme picture
    @IBOutlet weak var themeImg: UIImageView!
    
    // labels
    @IBOutlet weak var ideaLbl: UILabel!
    @IBOutlet weak var hashtagsLbl: UILabel!
    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var uuidLbl: UILabel!
    
    // buttons
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var usernameBtn: UIButton!
    
    @IBOutlet weak var bgView: UIView!
    
    
    // default
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // clear like button text color
        likeBtn.setTitleColor(UIColor.clear, for: UIControlState.normal)
        
        let width = UIScreen.main.bounds.width
        
        themeImg.translatesAutoresizingMaskIntoConstraints = false
        ideaLbl.translatesAutoresizingMaskIntoConstraints = false
        hashtagsLbl.translatesAutoresizingMaskIntoConstraints = false
        likeLbl.translatesAutoresizingMaskIntoConstraints = false
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        uuidLbl.translatesAutoresizingMaskIntoConstraints = false
        likeBtn.translatesAutoresizingMaskIntoConstraints = false
        usernameBtn.translatesAutoresizingMaskIntoConstraints = false
        bgView.translatesAutoresizingMaskIntoConstraints = false
        
        let themeWidth = width - 40
        let themeHeight = themeWidth / 16 * 9
        
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-20-[theme(\(themeHeight))]-10-[idea]-10-[hashtags]-5-[like(30)]-15-|",
            options: [], metrics: nil, views: ["theme": themeImg, "idea": ideaLbl, "hashtags": hashtagsLbl, "like": likeBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[hashtags]-10-[likes]",
            options: [], metrics: nil, views: ["hashtags": hashtagsLbl, "likes": likeLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[hashtags]-5-[username]",
            options: [], metrics: nil, views: ["hashtags": hashtagsLbl, "username": usernameBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[hashtags]-12-[date]",
            options: [], metrics: nil, views: ["hashtags": hashtagsLbl, "date": dateLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[theme]-15-|",
            options: [], metrics: nil, views: ["theme": themeImg]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-25-[idea]-25-|",
            options: [], metrics: nil, views: ["idea": ideaLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-25-[hashtags]-25-|",
            options: [], metrics: nil, views: ["hashtags": hashtagsLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-25-[like(30)]-10-[likes]",
            options: [], metrics: nil, views: ["like": likeBtn, "likes": likeLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[username]-10-[date]-25-|",
            options: [], metrics: nil, views: ["username": usernameBtn, "date":dateLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[bg]-5-|",
            options: [], metrics: nil, views: ["bg": bgView]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[bg]-10-|",
            options: [], metrics: nil, views: ["bg": bgView]))
        
        
        bgView.layer.zPosition = -1
        bgView.layer.cornerRadius = self.frame.size.width / 30
        bgView.clipsToBounds = true
        bgView.backgroundColor = .white
        
    }
    
    
    @IBAction func likeBtn_clicked(_ sender: Any) {
        // declear title of button
        let button = sender as! UIButton
        let title = button.title(for: UIControlState.normal)
        
        // to like
        if title == "unlike" {
            
            // update total # of likes of the post in posts table
            let totalLikesQuery = PFQuery(className: "posts")
            totalLikesQuery.whereKey("uuid", equalTo: uuidLbl.text!)
            totalLikesQuery.getFirstObjectInBackground { (object, error) in
                object?.incrementKey("likes", byAmount: 1)
                object?.saveInBackground(block: { (success, error) in
                    if success {
                        self.likeLbl.text = String((self.likeLbl.layer.value(forKey: "likes") as! NSString).intValue + 1)
                    }
                })
            }
            
            // add new like to likes table
            let object = PFObject(className: "likes")
            object["by"] = PFUser.current()?.username
            object["to"] = usernameBtn.titleLabel?.text
            object["uuid"] = uuidLbl.text
            object.saveInBackground { (success, error) in
                if success {
                    self.likeBtn.setTitle("like", for: UIControlState.normal)
                    self.likeBtn.setBackgroundImage(UIImage(named: "like.png"), for: UIControlState.normal)
                    
                    // send notification if user liked to refresh tableview
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liked"), object: nil)
                    
                    if self.usernameBtn.titleLabel!.text! != PFUser.current()?.username {
                        // send notification as like
                        let newsObj = PFObject(className: "news")
                        newsObj["by"] = PFUser.current()?.username
                        newsObj["to"] = self.usernameBtn.titleLabel!.text!
                        // newsObj["ava"] = PFUser.current()?.object(forKey: "ava") as! PFFile
                        newsObj["owner"] = self.usernameBtn.titleLabel!.text!
                        newsObj["uuid"] = self.uuidLbl.text
                        newsObj["type"] = "like"
                        newsObj["checked"] = "no"
                        newsObj.saveEventually()
                    }
                }
            }
        // to unlike
        } else {
            
            // update total # of likes of the post in posts table
            let totalLikesQuery = PFQuery(className: "posts")
            totalLikesQuery.whereKey("uuid", equalTo: uuidLbl.text!)
            totalLikesQuery.getFirstObjectInBackground { (object, error) in
                object?.incrementKey("likes", byAmount: -1)
                object?.saveInBackground(block: { (success, error) in
                    if success {
                        self.likeLbl.text = String(self.likeLbl.layer.value(forKey: "likes") as! NSString)
                    }
                })
            }
            
            // request existing likes of current to shown post
            let query = PFQuery(className: "likes")
            query.whereKey("by", equalTo: PFUser.current()!.username!)
            query.whereKey("uuid", equalTo: uuidLbl.text!)
            query.findObjectsInBackground { (objects, error) in
                
                // find likes
                for object in objects! {
                    
                    // delete likes
                    object.deleteInBackground(block: { (success, error) in
                        if success {
                            self.likeBtn.setTitle("unlike", for: UIControlState.normal)
                            self.likeBtn.setBackgroundImage(UIImage(named: "unlike.png"), for: UIControlState.normal)
                            
                            // send notification if user liked to refresh tableview
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liked"), object: nil)
                            
                            // delete notification: like
                            if self.usernameBtn.titleLabel!.text! != PFUser.current()?.username {
                                
                            }
                            let newsQuery = PFQuery(className: "news")
                            newsQuery.whereKey("by", equalTo: PFUser.current()!.username!)
                            newsQuery.whereKey("to", equalTo: self.usernameBtn.titleLabel!.text!)
                            newsQuery.whereKey("uuid", equalTo: self.uuidLbl.text!)
                            newsQuery.whereKey("type", equalTo: "like")
                            newsQuery.findObjectsInBackground(block: { (objects, error) in
                                if error == nil {
                                    for object in objects! {
                                        object.deleteEventually()
                                    }
                                } else {
                                    print(error!.localizedDescription)
                                }
                            })
                        }
                    })
                }
            }
        }
    }
    
}
