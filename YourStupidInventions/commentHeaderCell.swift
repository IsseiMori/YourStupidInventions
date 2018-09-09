//
//  commentHeaderCell.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/26/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse

class commentHeaderCell: UITableViewCell{

    // theme picture
    @IBOutlet weak var themeImg: UIImageView!
    
    // labels
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var ideaLbl: UILabel!
    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var uuidLbl: UILabel!
    @IBOutlet weak var themeuuid: UILabel!
    
    // buttons
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var usernameBtn: UIButton!
    @IBOutlet weak var postIdeaBtn: UIButton!
    
    @IBOutlet weak var bgView: UIView!
    
    // default
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("commentHeaderCell load header")
        let query = PFQuery(className: "posts")
        query.whereKey("uuid", equalTo: commentuuid.last!)
        query.getFirstObjectInBackground { (object, error) in
            if error == nil {
                
                self.titleLbl.text = object?.object(forKey: "title") as? String
                self.ideaLbl.text = object?.object(forKey: "idea") as? String
                self.likeLbl.text = String(object?.value(forKey: "likes") as! Int)
                self.uuidLbl.text = commentuuid.last!
                self.usernameBtn.setTitle(commentowner.last!, for: UIControlState.normal)
                self.themeuuid.text = object?.object(forKey: "themeuuid") as? String
                
                // place theme image
                (object?.object(forKey: "theme") as! PFFile).getDataInBackground { (data, error) in
                    
                    if error == nil {
                        self.themeImg.image = UIImage(data: data!)
                    } else {
                        print(error!.localizedDescription)
                    }
                }
                
                // calculate date
                let from = object?.createdAt
                let now = Date()
                let components: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
                let difference = (Calendar.current as NSCalendar).components(components, from: from!, to: now, options: [])
                
                if difference.second! <= 0 {
                    self.dateLbl.text = "now"
                }
                if difference.second! > 0 && difference.minute! == 0 {
                    self.dateLbl.text = "\(difference.second!)s. ago"
                }
                if difference.minute! > 0 && difference.hour! == 0 {
                    self.dateLbl.text = "\(difference.minute!)m. ago"
                }
                if difference.hour! > 0 && difference.day! == 0 {
                    self.dateLbl.text = "\(difference.hour!)h. ago"
                }
                if difference.day! > 0 && difference.weekOfMonth! == 0 {
                    self.dateLbl.text = "\(difference.day!)d. ago"
                }
                if difference.weekOfMonth! > 0 {
                    self.dateLbl.text = "\(difference.weekOfMonth!)w. ago"
                }
                
            }
        }
        
        // call align func
        alignment()
    }
    
    
    // alignment func
    func alignment() {
        
        let width = UIScreen.main.bounds.width
        
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        themeImg.translatesAutoresizingMaskIntoConstraints = false
        ideaLbl.translatesAutoresizingMaskIntoConstraints = false
        likeLbl.translatesAutoresizingMaskIntoConstraints = false
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        uuidLbl.translatesAutoresizingMaskIntoConstraints = false
        likeBtn.translatesAutoresizingMaskIntoConstraints = false
        usernameBtn.translatesAutoresizingMaskIntoConstraints = false
        bgView.translatesAutoresizingMaskIntoConstraints = false
        postIdeaBtn.translatesAutoresizingMaskIntoConstraints = false
        
        let themeWidth = width - 40
        let themeHeight = themeWidth / 16 * 9
        
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-20-[title]-10-[theme(\(themeHeight))]-10-[idea]-5-[like(30)]-5-[post(30)]-20-|",
            options: [], metrics: nil, views: ["title": titleLbl, "theme": themeImg, "idea": ideaLbl, "like": likeBtn, "post": postIdeaBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[idea]-10-[likes]",
            options: [], metrics: nil, views: ["idea": ideaLbl, "likes": likeLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[idea]-5-[username]",
            options: [], metrics: nil, views: ["idea": ideaLbl, "username": usernameBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[idea]-12-[date]",
            options: [], metrics: nil, views: ["idea": ideaLbl, "date": dateLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[title]-15-|",
            options: [], metrics: nil, views: ["title": titleLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[theme]-15-|",
            options: [], metrics: nil, views: ["theme": themeImg]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[theme]-15-|",
            options: [], metrics: nil, views: ["theme": themeImg]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-25-[idea]-25-|",
            options: [], metrics: nil, views: ["idea": ideaLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-25-[like(30)]-10-[likes]",
            options: [], metrics: nil, views: ["like": likeBtn, "likes": likeLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[username]-10-[date]-25-|",
            options: [], metrics: nil, views: ["username": usernameBtn, "date":dateLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-25-[post]-25-|",
            options: [], metrics: nil, views: ["post": postIdeaBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[bg]-10-|",
            options: [], metrics: nil, views: ["bg": bgView]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[bg]-10-|",
            options: [], metrics: nil, views: ["bg": bgView]))
        
        
        bgView.layer.zPosition = -1
        bgView.layer.cornerRadius = self.frame.size.width / 30
        bgView.clipsToBounds = true
        bgView.backgroundColor = .white
        
        likeBtn.setTitle("unlike", for: UIControlState.normal)
        
        // clear like button text color
        likeBtn.setTitleColor(UIColor.clear, for: UIControlState.normal)
        
        postIdeaBtn.backgroundColor = customColorYellow
        postIdeaBtn.layer.cornerRadius = 5
        
        
    }

}
