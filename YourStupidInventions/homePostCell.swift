//
//  homePostCell.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/27/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit

class homePostCell: UICollectionViewCell {
    
    // UI objects
    @IBOutlet weak var themeImg: UIImageView!
    @IBOutlet weak var ideaLbl: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    
    // default
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // alignment
        let width = UIScreen.main.bounds.width
        
        bgView.frame = CGRect(x: 5, y: 10, width: width / 2 - 10, height: width / 2 * 0.5625 + 50 + 5)
        themeImg.frame = CGRect(x: bgView.frame.origin.x + 1, y: bgView.frame.origin.y + 5, width: bgView.frame.size.width - 2, height: bgView.frame.size.width / 16 * 9)
        ideaLbl.frame = CGRect(x: bgView.frame.origin.x + 5, y: themeImg.frame.origin.y + themeImg.frame.size.height, width: bgView.frame.size.width - 10, height: 30)
        likeBtn.frame = CGRect(x: bgView.frame.origin.x + 5, y: ideaLbl.frame.origin.y + ideaLbl.frame.size.height, width: 20, height: 20)
        likesLbl.frame = CGRect(x: bgView.frame.origin.x + bgView.frame.size.width - 50 - 5, y: ideaLbl.frame.origin.y + ideaLbl.frame.size.height, width: 50, height: 20)
        
        bgView.layer.cornerRadius = bgView.frame.size.width / 25
        bgView.clipsToBounds = true
        bgView.backgroundColor = .white
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor.lightGray.cgColor
        
        
    }
}
