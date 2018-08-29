//
//  postIdeaHeader.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/28/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse

var postIdeaHeaderHeight: CGFloat = 0

class postIdeaHeader: UITableViewCell {

    // UI objects
    @IBOutlet weak var themeImg: UIImageView!
    @IBOutlet weak var themeuuidLbl: UILabel!
    @IBOutlet weak var ideaTxt: UITextView!
    @IBOutlet weak var hashtagsLbl: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    var themeImgPFFile: PFFile!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // call alignment func
        alignment()
    }
    
    func alignment() {
        
        let width = UIScreen.main.bounds.width
        let themeWidth = width - 40
        let themeHeight = themeWidth / 16 * 9
        
        postIdeaHeaderHeight = themeHeight + 160 + 5
        
        bgView.frame = CGRect(x: 10, y: 10, width: width - 20, height: postIdeaHeaderHeight)
        themeImg.frame = CGRect(x: bgView.frame.origin.x, y: bgView.frame.origin.y, width: themeWidth, height: themeHeight)
        ideaTxt.frame = CGRect(x: themeImg.frame.origin.x, y: themeImg.frame.origin.y + themeImg.frame.size.height, width: bgView.frame.size.width, height: 80)
        hashtagsLbl.frame = CGRect(x: bgView.frame.origin.x, y: ideaTxt.frame.origin.y + ideaTxt.frame.size.height, width: bgView.frame.size.width, height: 50)
        sendBtn.frame = CGRect(x: bgView.frame.origin.x, y: hashtagsLbl.frame.origin.y + hashtagsLbl.frame.size.height, width: bgView.frame.size.width, height: 30)
        
        ideaTxt.backgroundColor = UIColor.groupTableViewBackground
        
        ideaTxt.textContainer.maximumNumberOfLines = 3
        
        
        bgView.layer.zPosition = -1
        bgView.layer.cornerRadius = self.frame.size.width / 30
        bgView.clipsToBounds = true
        bgView.backgroundColor = .white
        
        sendBtn.layer.cornerRadius = self.frame.size.width / 100
        sendBtn.clipsToBounds = true
    }

    
    // clicked send button
    @IBAction func sendBtn_clicked(_ sender: Any) {
        
        let object = PFObject(className: "posts")

        // generate uuid for the new post
        let uuid = UUID().uuidString
        object["uuid"] = "\(PFUser.current()!.username!) \(uuid)"
        
        object["theme"] = themeImgPFFile
        object["idea"] = ideaTxt.text
        object["hashtags"] = hashtagsLbl.text
        object["username"] = PFUser.current()?.username
        object["fullname"] = PFUser.current()?.object(forKey: "fullname")
        object["likes"] = 0
        
        // copy the themeuuid
        object["themeuuid"] = themeuuidLbl.text
        
        object.saveInBackground { (success, error) in
            if success {
                
            } else {
                print(error!.localizedDescription)
            }
        }
 
    }
}
