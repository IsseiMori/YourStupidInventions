//
//  postIdeaHeader.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/28/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse

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
    
    var delegate: UITableViewController?
    
    // language of this post
    var lang: String!
    
    // title of the theme without what is:
    var title: String!
    
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
        
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        themeImg.translatesAutoresizingMaskIntoConstraints = false
        ideaTxt.translatesAutoresizingMaskIntoConstraints = false
        sendBtn.translatesAutoresizingMaskIntoConstraints = false
        bgView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-20-[title]-10-[theme(\(themeHeight))]-10-[idea(80)]-10-[send(30)]-20-|",
            options: [], metrics: nil, views: ["title": titleLbl, "theme": themeImg, "idea": ideaTxt, "send": sendBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[title]-15-|",
            options: [], metrics: nil, views: ["title": titleLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[theme]-10-|",
            options: [], metrics: nil, views: ["theme": themeImg]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[idea]-15-|",
            options: [], metrics: nil, views: ["idea": ideaTxt]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[send]-15-|",
            options: [], metrics: nil, views: ["send": sendBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[bg]-10-|",
            options: [], metrics: nil, views: ["bg": bgView]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[bg]-10-|",
            options: [], metrics: nil, views: ["bg": bgView]))
    
        
        ideaTxt.backgroundColor = UIColor.groupTableViewBackground
        
        ideaTxt.textContainer.maximumNumberOfLines = 3
        
        
        bgView.layer.zPosition = -1
        bgView.layer.cornerRadius = self.frame.size.width / 30
        bgView.clipsToBounds = true
        bgView.backgroundColor = .white
        
        
        sendBtn.layer.cornerRadius = 5
        sendBtn.clipsToBounds = true
        
        // disable send button untill everything is filled
        sendBtn.backgroundColor = UIColor.lightGray
        sendBtn.isEnabled = false
        sendBtn.setTitle(NSLocalizedString("Publish", comment: ""), for: UIControlState.normal)
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
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if isLoggedIn {
            return true
        } else {
            alert(title: NSLocalizedString("please sign in", comment: ""), message: NSLocalizedString("sign in from profile page", comment: ""))
            return false
        }
    }
    
    // changed textView
    func textViewDidChange(_ textView: UITextView) {
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
    
    // alert func
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        delegate!.present(alert, animated: true, completion: nil)
    }
}
