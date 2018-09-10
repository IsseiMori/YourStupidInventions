//
//  editVC.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/30/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse

class editVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    // UI objects
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // tap to choose image
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(self.loadImg))
        avaTap.numberOfTapsRequired = 1
        avaImg.isUserInteractionEnabled = true
        avaImg.addGestureRecognizer(avaTap)
        
        // call alignment func
        alignment()
        
        information()
    }


    // func to call UIImagePickerController
    @objc func loadImg(recognizer: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    
    // method to finilize UIImagePickerController action
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        avaImg.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    
    func alignment() {
        
        let width = self.view.frame.size.width
        
        avaImg.frame = CGRect(x: width / 2 - 40, y: (navigationController?.navigationBar.frame.size.height)! + 50, width: 80, height: 80)
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
        
        usernameTxt.frame = CGRect(x: 10, y: avaImg.frame.origin.y + 100, width: width - 20, height: 30)
        fullnameTxt.frame = CGRect(x: 10, y: usernameTxt.frame.origin.y + 40, width: width - 20, height: 30)
        emailTxt.frame = CGRect(x: 10, y: fullnameTxt.frame.origin.y + 40, width: width - 20, height: 30)
        
        // disable username editing
        usernameTxt.isEnabled = false
        usernameTxt.textColor = UIColor.lightGray
        
        // button title
        self.navigationItem.leftBarButtonItems![0].title = NSLocalizedString("Cancel", comment: "")
        self.navigationItem.rightBarButtonItems![0].title = NSLocalizedString("Save", comment: "")
        
        // background
        /*
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "bg.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        */
        
        // set delegate to textField to detect Enter
        fullnameTxt.delegate = self
        emailTxt.delegate = self
    }
    
    // user information function
    func information() {
        
        // receive profile picture
        let ava = PFUser.current()?.value(forKey: "ava") as! PFFile
        ava.getDataInBackground { (data, error) in
            if error == nil {
                self.avaImg.image = UIImage(data: data!)
            } else {
                print(error!.localizedDescription)
            }
        }
        
        // receive text information
        usernameTxt.text = String("@" + (PFUser.current()?.username)!)
        fullnameTxt.text = PFUser.current()?.object(forKey: "fullname") as? String

        
        emailTxt.text = PFUser.current()?.email
        
    }
    
    
    // Changed content in textField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" {
            if textField == usernameTxt {
                usernameTxt.resignFirstResponder()
            }
            if textField == fullnameTxt {
                fullnameTxt.resignFirstResponder()
            }
            return false
        }
        
        return true
    }

    
    // clicked send button
    @IBAction func sendBtn_clicked(_ sender: Any) {
        
        // if fields are empty
        if usernameTxt.text!.isEmpty || emailTxt.text!.isEmpty || fullnameTxt.text!.isEmpty {
            
            // alert message
            alert(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("fill in all fields", comment: ""))
            
            return
        }
        
        // email does not follow the format
        if !validateEmail(email: emailTxt.text!){
            
            // alert message
            alert(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("invalid email", comment: ""))
            
            return
        }
        
        
        // save filled in infromation
        let user = PFUser.current()!
        user.email = emailTxt.text?.lowercased()
        user["fullname"] = fullnameTxt.text?.lowercased()

        // save profile picture
        let avaData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
        let avaFile = PFFile(name: "ava.jpg", data: avaData!)
        user["ava"] = avaFile
        
        // send filled information to the server
        user.saveInBackground { (success, error) in
            if success {
                
                // hide keyboard
                self.view.endEditing(true)
                
                //dismiss editVC
                self.dismiss(animated: true, completion: nil)
                
                // send notification to reload homeVC
                // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil )
                
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    // clicked cancel button
    @IBAction func cancel_clicked(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
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
