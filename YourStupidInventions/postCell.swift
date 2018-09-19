//
//  postCell.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/26/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse
import Spring

class postCell: UITableViewCell {
    
    // theme picture
    @IBOutlet weak var themeImg: UIImageView!
    
    // labels
    @IBOutlet weak var ideaLbl: UILabel!
    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var uuidLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var ptLbl: UILabel!
    
    // buttons
    @IBOutlet weak var likeBtn: SpringButton!
    @IBOutlet weak var usernameBtn: UIButton!
    
    @IBOutlet weak var bgView: UIView!
    
    
    // default
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // clear like button text color
        likeBtn.setTitleColor(UIColor.clear, for: UIControlState.normal)
        
        let width = UIScreen.main.bounds.width
        
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        themeImg.translatesAutoresizingMaskIntoConstraints = false
        ideaLbl.translatesAutoresizingMaskIntoConstraints = false
        likeLbl.translatesAutoresizingMaskIntoConstraints = false
        ptLbl.translatesAutoresizingMaskIntoConstraints = false
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        uuidLbl.translatesAutoresizingMaskIntoConstraints = false
        likeBtn.translatesAutoresizingMaskIntoConstraints = false
        usernameBtn.translatesAutoresizingMaskIntoConstraints = false
        bgView.translatesAutoresizingMaskIntoConstraints = false
        
        let themeWidth = width - 20
        let themeHeight = themeWidth / 16 * 9
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-20-[title]-10-[theme(\(themeHeight))]-10-[idea]-(-10)-[like(70)]-0-|",
            options: [], metrics: nil, views: ["title": titleLbl, "theme": themeImg, "idea": ideaLbl, "like": likeBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[idea]-20-[likes]",
            options: [], metrics: nil, views: ["idea": ideaLbl, "likes": likeLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[idea]-20-[pt]",
            options: [], metrics: nil, views: ["idea": ideaLbl, "pt": ptLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[idea]-5-[username]",
            options: [], metrics: nil, views: ["idea": ideaLbl, "username": usernameBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[idea]-22-[date]",
            options: [], metrics: nil, views: ["idea": ideaLbl, "date": dateLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[title]-15-|",
            options: [], metrics: nil, views: ["title": titleLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[theme]-10-|",
            options: [], metrics: nil, views: ["theme": themeImg]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-25-[idea]-25-|",
            options: [], metrics: nil, views: ["idea": ideaLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[like(70)]-10-[likes]-[pt]",
            options: [], metrics: nil, views: ["like": likeBtn, "likes": likeLbl, "pt": ptLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[username]-10-[date]-25-|",
            options: [], metrics: nil, views: ["username": usernameBtn, "date":dateLbl]))
        
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
        
        likeLbl.sizeToFit()
        ptLbl.text = "pt"
        
    }
    
    
    @IBAction func likeBtn_clicked(_ sender: Any) {
        
        if isLoggedIn {
            
            likeBtn.animation = "pop"
            likeBtn.duration = 1
            likeBtn.animate()
            
            // change background image
            if likeBtn.titleLabel?.text != "like" {
                likeBtn.setTitle("like", for: UIControlState.normal)
                likeBtn.setBackgroundImage(UIImage(named: "money_like.png"), for: UIControlState.normal)
            }
            
            // increment likeLbl
            likeLbl.text = String(Int(likeLbl.text!)! + 1)
        }
    }
    
}
