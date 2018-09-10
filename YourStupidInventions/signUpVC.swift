//
//  signUpVC.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/26/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse

class signUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // profile image
    @IBOutlet weak var avaImg: UIImageView!
    
    // text fields
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var repeatPasswordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var fullnameTxt: UITextField!
    
    // buttons
    @IBOutlet weak var signUpBtn: UIButton!
    
    // scroll view
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    // reset default height
    var scrollViewHeight: CGFloat = 0
    
    // keyboard frame size
    var keyboard = CGRect()
    
    // send status
    var didSend = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("Sign Up", comment: "")

        // scrollView frame size
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        scrollView.contentSize.height = self.view.frame.size.height
        scrollViewHeight = scrollView.frame.size.height
        
        // check notifications if keyboard is shown or not
        NotificationCenter.default.addObserver(self, selector: #selector(self.showKeyboard), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideKeyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // declare hide keyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // round ava
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
        
        // declare select image tap
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(self.loadImg))
        avaTap.numberOfTapsRequired = 1
        avaImg.isUserInteractionEnabled = true
        avaImg.addGestureRecognizer(avaTap)
        
        
        // alignment
        avaImg.frame = CGRect(x: self.view.frame.size.width / 2 - 40, y: 40, width: 80, height: 80)
        usernameTxt.frame = CGRect(x: 10, y: avaImg.frame.origin.y + 90, width: self.view.frame.width - 20, height: 30)
        passwordTxt.frame = CGRect(x: 10, y: usernameTxt.frame.origin.y + 40, width: self.view.frame.width - 20, height: 30)
        repeatPasswordTxt.frame = CGRect(x: 10, y: passwordTxt.frame.origin.y + 40, width: self.view.frame.width - 20, height: 30)
        
        emailTxt.frame = CGRect(x: 10, y: repeatPasswordTxt.frame.origin.y + 60, width: self.view.frame.width - 20, height: 30)
        fullnameTxt.frame = CGRect(x: 10, y: emailTxt.frame.origin.y + 40, width: self.view.frame.width - 20, height: 30)
        
        signUpBtn.frame = CGRect(x: 10, y: fullnameTxt.frame.origin.y + 50, width: self.view.frame.size.width - 20, height: 30)
        signUpBtn.layer.cornerRadius = 5
        
        // background
        /*let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "bg.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)*/
        
        // disable signUp button untill every field is filled
        signUpBtn.backgroundColor = UIColor.lightGray
        signUpBtn.isEnabled = false
        
        usernameTxt.placeholder = NSLocalizedString("username", comment: "")
        passwordTxt.placeholder = NSLocalizedString("password", comment: "")
        repeatPasswordTxt.placeholder = NSLocalizedString("repeat password", comment: "")
        emailTxt.placeholder = NSLocalizedString("email", comment: "")
        fullnameTxt.placeholder = NSLocalizedString("fullname", comment: "")
        signUpBtn.setTitle(NSLocalizedString("Sign Up", comment: ""), for: UIControlState.normal)
        
        // set UITextField delegate
        usernameTxt.delegate = self
        passwordTxt.delegate = self
        repeatPasswordTxt.delegate = self
        emailTxt.delegate = self
        fullnameTxt.delegate = self
    }
    
    
    // call picker to select image
    @objc func loadImg(recognizer: UITapGestureRecognizer) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    
    // connect selected image to imageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // hide keyboard if tapped
    @objc func hideKeyboardTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    // show keyboard func
    @objc func showKeyboard(notification: NSNotification) {
        
        // define keyboard size
        keyboard = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue)!
        
        // move up UI
        UIView.animate(withDuration: 0.4) {
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.height
        }
        
        
    }
    
    
    // finished editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty || repeatPasswordTxt.text!.isEmpty || emailTxt.text!.isEmpty || fullnameTxt.text!.isEmpty {
            
            // disable signUp button untill every field is filled
            signUpBtn.backgroundColor = UIColor.lightGray
            signUpBtn.isEnabled = false
        } else {
            
            // enable signUp button if every field is filled
            signUpBtn.backgroundColor = customColorYellow
            signUpBtn.isEnabled = true
        }
    }
    
    
    // hide keyboard func
    @objc func hideKeyboard(notification: NSNotification) {
        // move down UI
        UIView.animate(withDuration: 0.4) {
            self.scrollView.frame.size.height = self.scrollViewHeight
        }
    }
    
    
    // clicked sing up
    @IBAction func singUpBtn_clicked(_ sender: Any) {
        
        // if status is already sent, return
        if didSend {
            return
        }
        
        // dismiss keyboard
        self.view.endEditing(true)
        
        // if fields are empty
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty || repeatPasswordTxt.text!.isEmpty || emailTxt.text!.isEmpty || fullnameTxt.text!.isEmpty {
            
            // alert message
            alert(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("fill in all fields", comment: ""))
            
            return
        }
        
        // if different password
        if passwordTxt.text != repeatPasswordTxt.text {
            
            // alert message
            alert(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("password do not match", comment: ""))
            
            return
        }
        
        // if username too short
        if (usernameTxt.text?.count)! < 6 {
            
            // alert message
            alert(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("username too short", comment: ""))
            
            return
        }
        
        // if username too short
        if (passwordTxt.text?.count)! < 6 {
            
            // alert message
            alert(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("password too short", comment: ""))
            
            return
        }
        
        
        // email does not follow the format
        if !validateEmail(email: emailTxt.text!){
            
            // alert message
            alert(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("invalid email", comment: ""))
            
            return
        }
        
        // if username is taken by another user
        let query = PFQuery(className: "_User")
        query.whereKey("username", contains: usernameTxt.text?.lowercased())
        query.countObjectsInBackground { (count, error) in
            if error == nil {
                if count != 0 {
                    // alert message
                    self.alert(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("username taken", comment: ""))
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        
        // change send status to yes
        didSend = true
        
        // send data to server to related columns
        let user = PFUser()
        user.username = usernameTxt.text?.lowercased()
        user.email = emailTxt.text?.lowercased()
        user.password = passwordTxt.text
        user["fullname"] = fullnameTxt.text?.lowercased()
        
        // convert profile image for sending to server
        let avaData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
        let avaFile = PFFile(name: "ava.jpg", data: avaData!)
        user["ava"] = avaFile
        
        // save data in server
        user.signUpInBackground { (success, error) in
            if success {
                
                // remember logged in user
                UserDefaults.standard.set(user.username, forKey: "username")
                UserDefaults.standard.synchronize()
                
                // call login func from AppDeligate.swift  class
                let appDeligate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDeligate.login()
                
            } else {
                // alert message
                self.alert(title: NSLocalizedString("Error", comment: ""), message: error!.localizedDescription)
            }
        }
        
        
    }
    
    // restrictions for email field
    func validateEmail(email: String) -> Bool {
        let regex = "[A-Z0-9a-z.%+-]{4}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2}"
        let range = email.range(of: regex, options: .regularExpression)
        let result = range != nil ? true : false
        return result
    }
    
    
    // alert func
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

}
