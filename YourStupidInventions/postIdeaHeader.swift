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
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var themeImg: UIImageView!
    @IBOutlet weak var ideaTxt: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    // hidden label to save theme data temporary
    @IBOutlet weak var themeuuidLbl: UILabel!
    @IBOutlet weak var adjLbl: UILabel!
    @IBOutlet weak var nounLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var hashtagsLbl: UILabel!
    
    var themeImgPFFile: PFFile!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // unable sendBtn if not yet logged in
        if !isLoggedIn {
            sendBtn.isEnabled = false
        }
        
        // call alignment func
        alignment()
    }
    
    func alignment() {
        
        let width = UIScreen.main.bounds.width
        let themeWidth = width - 40
        let themeHeight = themeWidth / 16 * 9
        
        postIdeaHeaderHeight = themeHeight + 155 + 15
        
        bgView.frame = CGRect(x: 10, y: 10, width: width - 20, height: postIdeaHeaderHeight)
        
        titleLbl.frame = CGRect(x: bgView.frame.origin.x + 10, y: bgView.frame.origin.y + 5, width: themeWidth, height: 30)
        themeImg.frame = CGRect(x: bgView.frame.origin.x + 10, y: titleLbl.frame.origin.y + titleLbl.frame.size.height + 5, width: themeWidth, height: themeHeight)
        ideaTxt.frame = CGRect(x: bgView.frame.origin.x + 10, y: themeImg.frame.origin.y + themeImg.frame.size.height + 5, width: bgView.frame.size.width - 20, height: 80)
        sendBtn.frame = CGRect(x: bgView.frame.origin.x + 10, y: ideaTxt.frame.origin.y + ideaTxt.frame.size.height + 5, width: bgView.frame.size.width - 20, height: 30)
        
        ideaTxt.backgroundColor = UIColor.groupTableViewBackground
        
        ideaTxt.textContainer.maximumNumberOfLines = 3
        
        
        bgView.layer.zPosition = -1
        bgView.layer.cornerRadius = self.frame.size.width / 30
        bgView.clipsToBounds = true
        bgView.backgroundColor = .white
        
        sendBtn.backgroundColor = UIColor(red: 255.0 / 255.0, green: 189.0 / 255.0, blue: 0.0 / 255.0, alpha: 1)
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
        object["username"] = PFUser.current()?.username
        object["fullname"] = PFUser.current()?.object(forKey: "fullname")
        object["likes"] = 0
        object["title"] = titleLbl.text!
        object["adjective"] = adjLbl.text!
        object["noun"] = nounLbl.text!
        object["category"] = categoryLbl.text!
        object["hashtags"] = hashtagsLbl.text!
        
        // copy the themeuuid
        object["themeuuid"] = themeuuidLbl.text
        
        object.saveInBackground { (success, error) in
            if success {
                // send notification with name "uploaded" to postIdeaVC to show newVC
                NotificationCenter.default.post(name: NSNotification.Name.init("uploaded"), object: nil)
                
                // reset text field
                self.ideaTxt.text = ""
                
            } else {
                print(error!.localizedDescription)
            }
        }
 
    }
}
