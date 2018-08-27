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
    
        let query = PFQuery(className: "posts")
        query.whereKey("uuid", equalTo: commentuuid.last!)
        query.getFirstObjectInBackground { (object, error) in
            if error == nil {
                
                self.ideaLbl.text = object?.object(forKey: "idea") as? String
                self.hashtagsLbl.text = object?.object(forKey: "hashtags") as? String
                self.likeLbl.text = String(object?.value(forKey: "likes") as! Int)
                self.uuidLbl.text = commentuuid.last!
                self.usernameBtn.setTitle(commentowner.last!, for: UIControlState.normal)
                
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
            withVisualFormat: "V:|-5-[bg]-5-|",
            options: [], metrics: nil, views: ["bg": bgView]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[bg]-10-|",
            options: [], metrics: nil, views: ["bg": bgView]))
        
        
        bgView.layer.zPosition = -1
        bgView.layer.cornerRadius = self.frame.size.width / 30
        bgView.clipsToBounds = true
        bgView.backgroundColor = .white
        
    }

}
