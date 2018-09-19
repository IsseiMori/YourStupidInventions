//
//  resetPasswordVC.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/31/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse

class resetPasswordVC: UIViewController {

    // text fields
    @IBOutlet weak var emailTxt: UITextField!
    
    // buttons
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    // Done button on keyboard
    var kbToolBar: UIToolbar!
    
    var ActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("Reset Password", comment: "")
        
        emailTxt.frame = CGRect(x: 10, y: 120, width: self.view.frame.size.width - 20, height:  30)
        resetBtn.frame = CGRect(x: 20, y: emailTxt.frame.origin.y + 50, width: self.view.frame.size.width / 4, height: 30)
        resetBtn.layer.cornerRadius = resetBtn.frame.size.width / 20
        
        cancelBtn.frame = CGRect(x: self.view.frame.size.width - self.view.frame.size.width / 4 - 20, y: resetBtn.frame.origin.y, width: self.view.frame.size.width / 4, height: 30)
        cancelBtn.layer.cornerRadius = cancelBtn.frame.size.width / 20
        
        emailTxt.placeholder = NSLocalizedString("email", comment: "")
        resetBtn.setTitle(NSLocalizedString("reset", comment: ""), for: UIControlState.normal)
        cancelBtn.setTitle(NSLocalizedString("Cancel", comment: ""), for: UIControlState.normal)
        
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
        emailTxt.inputAccessoryView = kbToolBar
        
        // Activity Indicator
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        ActivityIndicator.center = self.view.center
        ActivityIndicator.hidesWhenStopped = true
        ActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(ActivityIndicator)
        
        // background
        /*let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "bg.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)*/
        
        resetBtn.backgroundColor = customColorYellow
    }
    
    // tapped done button on keyboard
    @objc func doneButtonTapped() {
        self.view.endEditing(true)
    }
    
    // hide keyboard func
    @objc func hideKeyboard(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // clicked reset button
    @IBAction func resetBtn_click(_ sender: Any) {
        
        // start indicator animation
        ActivityIndicator.startAnimating()
        
        // hide keyboard
        self.view.endEditing(true)
        
        // if email textfield is empty
        if emailTxt.text!.isEmpty {
            // show alert message
            alert(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("email empty", comment: ""))
        }
        
        // request for resetting password
        PFUser.requestPasswordResetForEmail(inBackground: emailTxt.text!) { (success, error) in
            if success {
                // show alert message
                self.alert(title: NSLocalizedString("Password reset requested", comment: ""), message: NSLocalizedString("we sent you email", comment: ""))
                self.navigationController?.popViewController(animated: true)
            } else {
                self.alert(title: NSLocalizedString("Error", comment: ""), message: error!.localizedDescription)
            }
            
            // stop indicator animation
            self.ActivityIndicator.stopAnimating()
        }
    }
    
    // clicked cancel button
    @IBAction func cancelBtn_click(_ sender: Any) {
        
        // hide keyboard
        self.view.endEditing(true)
        
        // push back
        self.navigationController?.popViewController(animated: true)
    }
    
    // alert func
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
}
