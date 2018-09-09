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

class postIdeaHeader: UITableViewCell, UITextViewDelegate {

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
        
        // set delegate to detect Enter
        ideaTxt.delegate = self
        
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
        
        sendBtn.layer.cornerRadius = self.frame.size.width / 100
        sendBtn.clipsToBounds = true
        
        // disable send button untill everything is filled
        sendBtn.backgroundColor = UIColor.lightGray
        sendBtn.isEnabled = false
    }

    // ideaTxt content changed
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // if hit return key, dissimss keyboard
        if text == "\n" {
            ideaTxt.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    // finished editing
    func textViewDidEndEditing(_ textView: UITextView) {
        // disable send button if not everything is filled, enable otherwise
        if ideaTxt.text.isEmpty {
            
            // disable
            sendBtn.backgroundColor = UIColor.lightGray
            sendBtn.isEnabled = false
        } else {
            
            // enable
            sendBtn.backgroundColor = customColorYellow
            sendBtn.isEnabled = true
        }
    }
}
