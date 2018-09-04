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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Reset Password"
        
        emailTxt.frame = CGRect(x: 10, y: 120, width: self.view.frame.size.width - 20, height:  30)
        resetBtn.frame = CGRect(x: 20, y: emailTxt.frame.origin.y + 50, width: self.view.frame.size.width / 4, height: 30)
        resetBtn.layer.cornerRadius = resetBtn.frame.size.width / 20
        
        cancelBtn.frame = CGRect(x: self.view.frame.size.width - self.view.frame.size.width / 4 - 20, y: resetBtn.frame.origin.y, width: self.view.frame.size.width / 4, height: 30)
        cancelBtn.layer.cornerRadius = cancelBtn.frame.size.width / 20
        
        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: Selector(("hideKeyboard")))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // background
        /*let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "bg.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)*/
        
        resetBtn.backgroundColor = customColorYellow
    }
    
    // hide keyboard func
    func hideKeyboard(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // clicked reset button
    @IBAction func resetBtn_click(_ sender: Any) {
        
        // hide keyboard
        self.view.endEditing(true)
        
        // if email textfield is empty
        if emailTxt.text!.isEmpty {
            // show alert message
            let alert = UIAlertController(title: "Error", message: "email field is empty", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        
        // request for resetting password
        PFUser.requestPasswordResetForEmail(inBackground: emailTxt.text!) { (success, error) in
            if success {
                // show alert message
                let alert = UIAlertController(title: "Passward reset requested", message: "We have sent you an email", preferredStyle: UIAlertControllerStyle.alert)
                
                // if pressed OK, call self.dismiss function
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    // clicked cancel button
    @IBAction func cancelBtn_click(_ sender: Any) {
        
        // hide keyboard
        self.view.endEditing(true)
        
        // push back
        self.navigationController?.popViewController(animated: true)
    }

    
}
