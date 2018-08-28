//
//  postIdeaHeader.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/28/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit

class postIdeaHeader: UITableViewCell {

    // UI objects
    @IBOutlet weak var themeImg: UIImageView!
    @IBOutlet weak var themeuuidLbl: UILabel!
    @IBOutlet weak var ideaTxt: UITextView!
    @IBOutlet weak var hashtagsLbl: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let width = UIScreen.main.bounds.width
        
        themeImg.translatesAutoresizingMaskIntoConstraints = false
        ideaTxt.translatesAutoresizingMaskIntoConstraints = false
        hashtagsLbl.translatesAutoresizingMaskIntoConstraints = false
        themeuuidLbl.translatesAutoresizingMaskIntoConstraints = false
        sendBtn.translatesAutoresizingMaskIntoConstraints = false
        bgView.translatesAutoresizingMaskIntoConstraints = false
        
        let themeWidth = width - 40
        let themeHeight = themeWidth / 16 * 9
        
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-20-[theme(\(themeHeight))]-10-[idea(200)]-5-[hashtags)]-5-[send(20)]-5-|",
            options: [], metrics: nil, views: ["theme": themeImg, "idea": ideaTxt, "hashtags": hashtagsLbl, "send": sendBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[theme]-15-|",
            options: [], metrics: nil, views: ["theme": themeImg]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-25-[idea]-25-|",
            options: [], metrics: nil, views: ["idea": ideaTxt]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-25-[hashtags]-25-|",
            options: [], metrics: nil, views: ["hashtags": hashtagsLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-25-[send]-25-|",
            options: [], metrics: nil, views: ["send": sendBtn]))
    
        
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
