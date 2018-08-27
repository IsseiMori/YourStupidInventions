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
            withVisualFormat: "V:|-10-[bg]-0-|",
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
