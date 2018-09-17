//
//  reportProblemVC.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 9/9/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse

class reportProblemVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var problemTxt: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    
    // send status
    var didSend = false
    
    // Done button on keyboard
    var kbToolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("Report a problem", comment: "")
        
        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // done button on keyboard
        kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default
        kbToolBar.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneButtonTapped))
        kbToolBar.items = [spacer, doneButton]
        problemTxt.inputAccessoryView = kbToolBar
        
        problemTxt.delegate = self

        // alignment
        let width = self.view.frame.size.width
        titleLbl.frame = CGRect(x: 10, y: 20, width: width - 20, height: 30)
        problemTxt.frame = CGRect(x: 10, y: titleLbl.frame.origin.y + titleLbl.frame.size.height, width: width - 20, height: 100)
        sendBtn.frame = CGRect(x: 10, y: problemTxt.frame.origin.y + problemTxt.frame.size.height + 10, width: width - 20, height: 30)
        
        problemTxt.layer.cornerRadius = 5
        
        sendBtn.setTitle(NSLocalizedString("Send", comment: ""), for: UIControlState.normal)
        sendBtn.layer.cornerRadius = 5
        sendBtn.backgroundColor = UIColor.lightGray
        sendBtn.isEnabled = false
        
        titleLbl.text = NSLocalizedString("Explain the problem", comment: "")
        
    }
    
    // hide keyboard
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    // tapped done button on keyboard
    @objc func doneButtonTapped() {
        self.view.endEditing(true)
    }
    
    
    // changed textView
    func textViewDidChange(_ textView: UITextView) {
        // disable send button if not everything is filled, enable otherwise
        if problemTxt.text.isEmpty {
            
            // disable
            sendBtn.backgroundColor = UIColor.lightGray
            sendBtn.isEnabled = false
        } else {
            
            // enable
            sendBtn.backgroundColor = customColorYellow
            sendBtn.isEnabled = true
        }
    }

    
    // clicked send button
    @IBAction func sendBtn_clicked(_ sender: Any) {
        
        // if status is already sent, return
        if didSend {
            return
        }
        
        if problemTxt.text.isEmpty {
            alert(title: "Error", message: "Please write a problem.")
            return
        }
        
        // change send status to yes
        didSend = true
        
        // send problem report to server
        let issueObj = PFObject(className: "issues")
        issueObj["by"] = PFUser.current()?.username
        issueObj["issue"] = problemTxt.text
        issueObj.saveInBackground(block: { (success, error) in
            if success {
                
                self.alertBack(title: "Issue report has been made successfully", message: "Thank you for reporting the problem.")
                
                // reset UI
                self.problemTxt.text = ""
                
                // disable send button
                self.sendBtn.backgroundColor = UIColor.lightGray
                self.sendBtn.isEnabled = false
                
            } else {
                self.alert(title: "Error", message: error!.localizedDescription)
            }
        })
    }
    
    
    // alert func
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    // alert back func
    func alertBack(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
}
