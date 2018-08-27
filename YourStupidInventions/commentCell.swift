//
//  commentCell.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/26/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse

class commentCell: UITableViewCell {
    
    
    // UI objects
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var usernameBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    

    // default
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // alignment
        commentLbl.translatesAutoresizingMaskIntoConstraints = false
        usernameBtn.translatesAutoresizingMaskIntoConstraints = false
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[username]-0-[comment]-10-|",
            options: [], metrics: nil, views: ["username": usernameBtn, "comment": commentLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[date]",
            options: [], metrics: nil, views: ["date": dateLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[username]",
            options: [], metrics: nil, views: ["username": usernameBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[date]-10-|",
            options: [], metrics: nil, views: ["date": dateLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[comment]-10-|",
            options: [], metrics: nil, views: ["comment": commentLbl]))
        
        
    }

}
