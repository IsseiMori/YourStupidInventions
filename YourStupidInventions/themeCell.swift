//
//  themeCell.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/28/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit

class themeCell: UITableViewCell {
    
    
    // UI objects
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var themeImg: UIImageView!
    @IBOutlet weak var themeuuidLbl: UILabel!
    @IBOutlet weak var postsLbl: UILabel!
    @IBOutlet weak var postsBtn: UIButton!
    @IBOutlet weak var postIdeaBtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        let width = UIScreen.main.bounds.width
        
        themeImg.translatesAutoresizingMaskIntoConstraints = false
        postsLbl.translatesAutoresizingMaskIntoConstraints = false
        themeuuidLbl.translatesAutoresizingMaskIntoConstraints = false
        postsBtn.translatesAutoresizingMaskIntoConstraints = false
        postIdeaBtn.translatesAutoresizingMaskIntoConstraints = false
        bgView.translatesAutoresizingMaskIntoConstraints = false
        
        let themeWidth = width - 20
        let themeHeight = themeWidth / 16 * 9
        
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-20-[title]-10-[theme(\(themeHeight))]-10-[posts(30)]-15-|",
            options: [], metrics: nil, views: ["title": titleLbl, "theme": themeImg, "posts": postsBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[theme]-15-[posts]",
            options: [], metrics: nil, views: ["theme": themeImg, "posts": postsLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[theme]-10-[post(30)]",
            options: [], metrics: nil, views: ["theme": themeImg, "post": postIdeaBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[title]-15-|",
            options: [], metrics: nil, views: ["title": titleLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[theme]-10-|",
            options: [], metrics: nil, views: ["theme": themeImg]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-25-[postsBtn(30)]-10-[posts]",
            options: [], metrics: nil, views: ["postsBtn": postsBtn, "posts": postsLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[post(150)]-20-|",
            options: [], metrics: nil, views: ["post": postIdeaBtn]))
        
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
        
        postIdeaBtn.backgroundColor = UIColor(red: 255.0 / 255.0, green: 189.0 / 255.0, blue: 0.0 / 255.0, alpha: 1)
        postIdeaBtn.layer.cornerRadius = 5
        postIdeaBtn.clipsToBounds = true
        postIdeaBtn.setTitle(NSLocalizedString("Post your idea", comment: ""), for: UIControlState.normal)
    }


}
