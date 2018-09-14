//
//  homeHeaderView.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/27/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse

class homeHeaderView: UICollectionReusableView {
    
    // UI objects
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    
    @IBOutlet weak var ideas: UILabel!
    @IBOutlet weak var likes: UILabel!
    
    @IBOutlet weak var ideasTitle: UILabel!
    @IBOutlet weak var likesTitle: UILabel!
    
    
    // default
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // alignment
        let width = UIScreen.main.bounds.width
        
        avaImg.frame = CGRect(x: width / 16, y: width / 16, width: width / 6, height: width / 6)
        
        ideas.frame = CGRect(x: width / 2.5, y: avaImg.frame.origin.y + 5, width: 50, height: 30)
        likes.frame = CGRect(x: width / 1.6, y: avaImg.frame.origin.y + 5, width: 50, height: 30)
        
        fullnameLbl.frame = CGRect(x: avaImg.frame.origin.x + 5, y: avaImg.frame.origin.y + avaImg.frame.size.height, width: width - 30, height: 30)
        
        usernameLbl.frame = CGRect(x: avaImg.frame.origin.x + 5, y: fullnameLbl.frame.origin.y + fullnameLbl.frame.size.height - 10, width: width - 30, height: 20)
        
        ideasTitle.text = NSLocalizedString("ideas", comment: "")
        ideasTitle.sizeToFit()
        ideasTitle.center = CGPoint(x: ideas.center.x, y: ideas.center.y + 20)
        
        likesTitle.text = NSLocalizedString("likes", comment: "")
        likesTitle.sizeToFit()
        likesTitle.center = CGPoint(x: likes.center.x, y: likes.center.y + 20)
        
        // round profile picture
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
    }
    
}
