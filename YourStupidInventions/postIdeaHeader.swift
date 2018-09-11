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
    @IBOutlet weak var langBtn: PickerViewKeyboard!
    @IBOutlet weak var langBtnTri: UIButton!
    
    // hidden label to save theme data temporary
    @IBOutlet weak var themeuuidLbl: UILabel!
    @IBOutlet weak var adjLbl: UILabel!
    @IBOutlet weak var nounLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var hashtagsLbl: UILabel!
    
    var themeImgPFFile: PFFile!
    
    var langs = [NSLocalizedString("English", comment: ""),
                 NSLocalizedString("Japanese", comment: ""),
                 NSLocalizedString("Chinese", comment: "")]
    
    var delegate: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // unable sendBtn if not yet logged in
        if !isLoggedIn {
            sendBtn.isEnabled = false
        }
        
        // set delegate to detect Enter
        ideaTxt.delegate = self
        
        // enable picker
        langBtn.delegate = self
        
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
        langBtn.frame = CGRect(x: bgView.frame.origin.x + 10, y: ideaTxt.frame.origin.y + ideaTxt.frame.size.height + 5, width: bgView.frame.size.width * 0.3 - 10, height: 30)
        langBtnTri.frame = CGRect(x: bgView.frame.origin.x + 15, y: ideaTxt.frame.origin.y + ideaTxt.frame.size.height + 13, width: 16, height: 14)
        sendBtn.frame = CGRect(x: bgView.frame.origin.x + bgView.frame.size.width - bgView.frame.size.width * 0.65, y: ideaTxt.frame.origin.y + ideaTxt.frame.size.height + 5, width: bgView.frame.size.width * 0.65 - 10, height: 30)
        
        ideaTxt.backgroundColor = UIColor.groupTableViewBackground
        
        ideaTxt.textContainer.maximumNumberOfLines = 3
        
        
        bgView.layer.zPosition = -1
        bgView.layer.cornerRadius = self.frame.size.width / 30
        bgView.clipsToBounds = true
        bgView.backgroundColor = .white
        
        langBtn.backgroundColor = .clear
        langBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        langBtn.layer.cornerRadius = 5
        langBtn.layer.borderWidth = 1
        langBtn.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        langBtnTri.isUserInteractionEnabled = false
        
        // set post language as default language
        if selectedLanguages.count == 0 {
            langBtn.setTitle(NSLocalizedString("English", comment: ""), for: UIControlState.normal)
        } else {
            langBtn.setTitle(NSLocalizedString(selectedLanguages[0], comment: ""), for: UIControlState.normal)
        }
        
        sendBtn.layer.cornerRadius = self.frame.size.width / 100
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
    
    // alert func
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        delegate!.present(alert, animated: true, completion: nil)
    }
}

extension postIdeaHeader: PickerViewKeyboardDelegate {
    func titlesOfPickerViewKeyboard(sender: PickerViewKeyboard) -> Array<String> {
        return langs
    }
    func initSelectedRow(sender: PickerViewKeyboard) -> Int {
        return langs.count
    }
    func didDone(sender: PickerViewKeyboard, selectedData: String) {
        langBtn.setTitle(selectedData, for: UIControlState.normal)
        langBtn.resignFirstResponder()
    }
    func didCancel(sender: PickerViewKeyboard) {
        langBtn.resignFirstResponder()
    }
}
