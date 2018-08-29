//
//  notificationsCell.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/29/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit

class notificationsCell: UITableViewCell {

    // UI objects
    @IBOutlet weak var usernameBtn: UIButton!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        usernameBtn.translatesAutoresizingMaskIntoConstraints = false
        infoLbl.translatesAutoresizingMaskIntoConstraints = false
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[username]-7-[info]",
            options: [], metrics: nil, views: ["username": usernameBtn, "info": infoLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[date]-20-|",
            options: [], metrics: nil, views: ["date": dateLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[username(30)]",
            options: [], metrics: nil, views: ["username": usernameBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[info(30)]",
            options: [], metrics: nil, views: ["info": infoLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[date(30)]",
            options: [], metrics: nil, views: ["date": dateLbl]))
        
    }


}
