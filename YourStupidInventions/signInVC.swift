//
//  signInVC.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/26/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse


class signInVC: UIViewController {
    
    // text fields
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    // buttons
    @IBOutlet weak var forgotBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    // Done button on keyboard
    var kbToolBar: UIToolbar!
    
    var ActivityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("Sign In", comment: "")
        self.navigationItem.hidesBackButton = true
        
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
        usernameTxt.inputAccessoryView = kbToolBar
        passwordTxt.inputAccessoryView = kbToolBar
        
        // Activity Indicator
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        ActivityIndicator.center = self.view.center
        ActivityIndicator.hidesWhenStopped = true
        ActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(ActivityIndicator)
        
        // call alignment func
        alignment()
        
    }
    
    // tapped done button on keyboard
    @objc func doneButtonTapped() {
        self.view.endEditing(true)
    }
    
    // hide keyboard
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    // alignment func
    func alignment() {
        
        // font of label
        //label.font = UIFont(name: "Pacifico", size: 25)
        label.textColor = customColorYellow
        
        label.frame = CGRect(x: 10, y: 80, width: self.view.frame.size.width - 20, height: 50)
        usernameTxt.frame = CGRect(x: 10, y: label.frame.origin.y + 70, width: self.view.frame.size.width - 20, height: 30)
        passwordTxt.frame = CGRect(x: 10, y: usernameTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        forgotBtn.frame = CGRect(x: 10, y: passwordTxt.frame.origin.y + 30, width: self.view.frame.size.width - 20, height: 30)
        
        signInBtn.frame = CGRect(x: 20, y: forgotBtn.frame.origin.y + 40, width: self.view.frame.size.width / 4, height: 30)
        signInBtn.layer.cornerRadius = signInBtn.frame.size.width / 20
        
        signUpBtn.frame = CGRect(x: self.view.frame.width - self.view.frame.size.width / 4 - 20, y: signInBtn.frame.origin.y, width: self.view.frame.size.width / 4, height: 30)
        signUpBtn.layer.cornerRadius = signUpBtn.frame.size.width / 20
        
        // background
        /*let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "bg.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        */
        
        forgotBtn.setTitleColor(customColorYellow, for: UIControlState.normal)
        
        signInBtn.backgroundColor = customColorYellow
        signUpBtn.backgroundColor = customColorYellow
        
        // set labels
        label.text = NSLocalizedString("Your-Stupid-Inventions", comment: "")
        usernameTxt.placeholder = NSLocalizedString("username", comment: "")
        passwordTxt.placeholder = NSLocalizedString("password", comment: "")
        forgotBtn.setTitle(NSLocalizedString("forgot password?", comment: ""), for: UIControlState.normal)
        signInBtn.setTitle(NSLocalizedString("Sign In", comment: ""), for: UIControlState.normal)
        signUpBtn.setTitle(NSLocalizedString("Sign Up", comment: ""), for: UIControlState.normal)
    }

    
    // clicked sign in button
    @IBAction func signInBtn_clicked(_ sender: Any) {
        
        // start indicator animation
        ActivityIndicator.startAnimating()
        
        // hide keyboard
        self.view.endEditing(true)
        
        // if textfields are empty
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            
            // alert message
            alert(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("fill in all fields", comment: ""))
        }
        
        // login functions
        PFUser.logInWithUsername(inBackground: usernameTxt.text!, password: passwordTxt.text!) { (user, error) in
            if error == nil {
                
                // remember user
                UserDefaults.standard.set(user!.username, forKey: "username")
                UserDefaults.standard.synchronize()
                
                // call login function from AppDeligate.swift class
                let appDeligate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDeligate.login()
                appDeligate.resetView()
                
            } else {
                // alert message
                self.alert(title: "Error", message: NSLocalizedString("invalid username/password", comment: ""))
            }
            
            // stop indicator animation
            self.ActivityIndicator.stopAnimating()
        }
    }
    
    
    // alert func
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
}
