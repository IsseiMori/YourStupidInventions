//
//  themesHeaderCell.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 9/3/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit

class themesHeaderCell: UITableViewCell {
    
    @IBOutlet weak var postThemeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        postThemeBtn.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[button]-5-|",
            options: [], metrics: nil, views: ["button": postThemeBtn]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[button]-10-|",
            options: [], metrics: nil, views: ["button": postThemeBtn]))
        
        postThemeBtn.backgroundColor = UIColor(red: 255.0 / 255.0, green: 189.0 / 255.0, blue: 0.0 / 255.0, alpha: 1)
        postThemeBtn.layer.cornerRadius = 10
        postThemeBtn.clipsToBounds = true
        postThemeBtn.setTitle(NSLocalizedString("Post your own theme", comment: ""), for: UIControlState.normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
