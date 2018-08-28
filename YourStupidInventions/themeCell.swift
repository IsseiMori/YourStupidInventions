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
    @IBOutlet weak var themeImg: UIImageView!
    @IBOutlet weak var themeuuidLbl: UILabel!
    @IBOutlet weak var hashtagsLbl: UILabel!
    @IBOutlet weak var postsLbl: UILabel!
    @IBOutlet weak var postsBtn: UIButton!
    @IBOutlet weak var postIdeaBtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        let width = UIScreen.main.bounds.width
        
        themeImg.translatesAutoresizingMaskIntoConstraints = false
        hashtagsLbl.translatesAutoresizingMaskIntoConstraints = false
        postsLbl.translatesAutoresizingMaskIntoConstraints = false
        themeuuidLbl.translatesAutoresizingMaskIntoConstraints = false
        postsBtn.translatesAutoresizingMaskIntoConstraints = false
        postIdeaBtn.translatesAutoresizingMaskIntoConstraints = false
        bgView.translatesAutoresizingMaskIntoConstraints = false
        
        let themeWidth = width - 40
        let themeHeight = themeWidth / 16 * 9
        
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-20-[theme(\(themeHeight))]-10-[hashtags]-5-[posts(30)]-15-|",
            options: [], metrics: nil, views: ["theme": themeImg, "hashtags": hashtagsLbl, "posts": postsBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[hashtags]-10-[posts]",
            options: [], metrics: nil, views: ["hashtags": hashtagsLbl, "posts": postsLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[hashtags]-5-[post(30)]",
            options: [], metrics: nil, views: ["hashtags": hashtagsLbl, "post": postIdeaBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[theme]-15-|",
            options: [], metrics: nil, views: ["theme": themeImg]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-25-[hashtags]-25-|",
            options: [], metrics: nil, views: ["hashtags": hashtagsLbl]))
        
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
    }


}
