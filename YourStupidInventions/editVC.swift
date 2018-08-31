//
//  editVC.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/30/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse

class editVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // UI objects
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var logoutBtn: UIButton!
    
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
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
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
        logoutBtn.frame = CGRect(x: 10, y: emailTxt.frame.origin.y + 40, width: width - 20, height: 30)
        
        // disable username editing
        usernameTxt.isEnabled = false
        usernameTxt.textColor = UIColor.lightGray
        
        // background
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "bg.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
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

    
    // clicked cancel button
    @IBAction func cancel_clicked(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // clicked logout button
    @IBAction func logoutBtn_clicked(_ sender: Any) {
        PFUser.logOutInBackground { (error) in
            if error == nil {
                
                // remove logged in username from app memory
                UserDefaults.standard.removeObject(forKey: "username")
                UserDefaults.standard.synchronize()
                
                self.view.endEditing(true)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
