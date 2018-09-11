//
//  postThemeVC.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 9/3/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse
import RSKImageCropper

class postThemeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource, UITextFieldDelegate {
    
    // UI objects
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var themeImg: UIImageView!
    @IBOutlet weak var nounTxt: UITextField!
    
    @IBOutlet weak var adjBtn: PickerViewKeyboard!
    @IBOutlet weak var categoryBtn: PickerViewKeyboard!
    @IBOutlet weak var langBtn: PickerViewKeyboard!
    
    @IBOutlet weak var adjBtnTri: UIButton!
    @IBOutlet weak var categoryBtnTri: UIButton!
    @IBOutlet weak var langBtnTri: UIButton!
    
    @IBOutlet weak var sendBtn: UIButton!
    
    
    // send status to avoid sending twice
    var didSend = false
    
    // image picker status
    var isImgPicked = false
    
    // pickerView and pickerData
    var adjs = [NSLocalizedString("Innovative", comment: ""),
                NSLocalizedString("Unexpected", comment: ""),
                NSLocalizedString("Future", comment: "")]
    var categories = [NSLocalizedString("Appliance", comment: ""),
                      NSLocalizedString("Software", comment: ""),
                      NSLocalizedString("Food", comment: ""),
                      NSLocalizedString("Entertainment", comment: ""),
                      NSLocalizedString("Sports", comment: ""),
                      NSLocalizedString("Others", comment: "")]
    var langs = [NSLocalizedString("English", comment: ""),
                 NSLocalizedString("Japanese", comment: ""),
                 NSLocalizedString("Chinese", comment: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("Post Theme", comment: "")
        

        // tap to choose image
        let themeTap = UITapGestureRecognizer(target: self, action: #selector(self.loadImg))
        themeTap.numberOfTapsRequired = 1
        themeImg.isUserInteractionEnabled = true
        themeImg.addGestureRecognizer(themeTap)
        
        // new back button
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.back))
        self.navigationItem.leftBarButtonItem = backBtn
        
        // swipe to back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.back))
        backSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(backSwipe)
        
        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // enable UITextView functions
        nounTxt.delegate = self
        
        adjBtn.delegate = self
        categoryBtn.delegate = self
        langBtn.delegate = self
        
        
        // call alignment fun
        alignment()
    }
    
    
    // hide keyboard
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    
    // go back to the previous view
    @objc func back(sender: UITabBarItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // alignment func
    func alignment() {
        
        let width = self.view.frame.size.width
        
        titleLbl.frame = CGRect(x: 10, y: 10, width: width - 20, height: 30)
        
        let themeImgWidth = width - 20
        let themeImgHeight = themeImgWidth / 16 * 9
        themeImg.frame = CGRect(x: 10, y: titleLbl.frame.origin.y + 30, width: themeImgWidth, height: themeImgHeight)
        
        adjBtn.frame = CGRect(x: 10, y: themeImg.frame.origin.y + themeImgHeight + 10, width: width * 0.45, height: 30)
        adjBtnTri.frame = CGRect(x: 15, y: themeImg.frame.origin.y + themeImgHeight + 18, width: 16, height: 14)
        
        categoryBtn.frame = CGRect(x: width - 10 - width * 0.45, y: themeImg.frame.origin.y + themeImgHeight + 10, width: width * 0.45, height: 30)
        categoryBtnTri.frame = CGRect(x: width - 10 - width * 0.45 + 5, y: themeImg.frame.origin.y + themeImgHeight + 18, width: 16, height: 14)
        
        nounTxt.frame = CGRect(x: 10, y: adjBtn.frame.origin.y + adjBtn.frame.size.height + 10, width: width * 0.7, height: 30)
        langBtn.frame = CGRect(x: width - width * 0.2 - 10, y: adjBtn.frame.origin.y + adjBtn.frame.size.height + 10, width: width * 0.2, height: 30)
        langBtnTri.frame = CGRect(x: width - width * 0.2 - 10 + 5, y: adjBtn.frame.origin.y + adjBtn.frame.size.height + 18, width: 16, height: 14)
        sendBtn.frame = CGRect(x: 10, y: nounTxt.frame.origin.y + nounTxt.frame.size.height + 10, width: width - 20, height: 30)
        
        sendBtn.layer.cornerRadius = 5
        sendBtn.clipsToBounds = true
        
        // disable send button untill everything is filled
        sendBtn.backgroundColor = UIColor.lightGray
        sendBtn.isEnabled = false
        
        adjBtn.backgroundColor = .clear
        adjBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        adjBtn.layer.cornerRadius = 5
        adjBtn.layer.borderWidth = 1
        adjBtn.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        adjBtnTri.isUserInteractionEnabled = false
        
        categoryBtn.backgroundColor = .clear
        categoryBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        categoryBtn.layer.cornerRadius = 5
        categoryBtn.layer.borderWidth = 1
        categoryBtn.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        adjBtnTri.isUserInteractionEnabled = false
        
        langBtn.backgroundColor = .clear
        langBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        langBtn.layer.cornerRadius = 5
        langBtn.layer.borderWidth = 1
        langBtn.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        langBtnTri.isUserInteractionEnabled = false
        
        nounTxt.placeholder = NSLocalizedString("Type noun", comment: "")
        sendBtn.setTitle(NSLocalizedString("Publish", comment: ""), for: UIControlState.normal)
        
        // set post language as default language
        if selectedLanguages.count == 0 {
            langBtn.setTitle(NSLocalizedString("English", comment: ""), for: UIControlState.normal)
        } else {
            langBtn.setTitle(NSLocalizedString(selectedLanguages[0], comment: ""), for: UIControlState.normal)
        }
        
        // set the first row as default
        adjBtn.setTitle(NSLocalizedString(adjs[0], comment: ""), for: UIControlState.normal)
        categoryBtn.setTitle(NSLocalizedString(categories[0], comment: ""), for: UIControlState.normal)
        
        // set title label
        titleLbl.text = "\(adjBtn.titleLabel!.text!) \(nounTxt.text!)"
    
    }

    /* UIImagePickerControllerDelegate */
    
    // func to call UIImagePickerController
    @objc func loadImg(recognizer: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
        
    }
    
    
    // method to finilize UIImagePickerController action
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // dissmiss image picker
        self.dismiss(animated: true, completion: nil)
        
        // show RSKImageCropper
        let image =  info[UIImagePickerControllerOriginalImage] as? UIImage
        let imageCropVC = RSKImageCropViewController(image: image!, cropMode: .custom)
        imageCropVC.moveAndScaleLabel.isHidden = true
        imageCropVC.cancelButton.setTitle("Cancel", for: .normal)
        imageCropVC.chooseButton.setTitle("Choose", for: .normal)
        imageCropVC.delegate = self
        imageCropVC.dataSource = self
        present(imageCropVC, animated: true)
        
    }
    
    /* UIImagePickerControllerDelegate END */

    
    /* RSKImageCropViewControllerDataSource */
    
    // define crop mask size
    func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
        
        let width = self.view.frame.size.width - 40
        let height = width / 16 * 9
        
        return CGRect(x: 20, y: self.view.center.y - height / 2, width: width, height: height)
    }
    
    
    // define crop mask path
    func imageCropViewControllerCustomMaskPath(_ controller: RSKImageCropViewController) -> UIBezierPath {
        
        return UIBezierPath(rect: controller.maskRect)
    }
    
    
    // return custom crop mask
    func imageCropViewControllerCustomMovementRect(_ controller: RSKImageCropViewController) -> CGRect {
        return controller.maskRect
    }
    
    /* RSKImageCropViewControllerDataSource END */
    
    
    /* RSKImageCropViewControllerDelegate */
    
    // custom crop canceled
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // custome crop finished
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        dismiss(animated: true)
        themeImg.image = croppedImage
        
        isImgPicked = true
    }
    
    /* RSKImageCropViewControllerDelegate END */
    
    // PICKER VIEW METHODS
    // picker comp number
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    /* UITextFieldDelegate */
    
    // finished editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        // update title label
        titleLbl.text = "\(adjBtn.titleLabel!.text!) \(nounTxt.text!)"
        
        // disable send button if not everything is filled, enable otherwise
        if nounTxt.text!.isEmpty {
            
            // disable
            sendBtn.backgroundColor = UIColor.lightGray
            sendBtn.isEnabled = false
        } else {
            
            // enable
            sendBtn.backgroundColor = customColorYellow
            sendBtn.isEnabled = true
        }
    }
    
    
    // typed a character
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // if entered return, dismiss keyboard
        if string == "\n" {
            nounTxt.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    /* UITextFieldDelegate END*/
    
    
    // clicked send button
    @IBAction func sendBtn_clicked(_ sender: Any) {
        
        // if status is already sent, return
        if didSend {
            return
        }
        
        if nounTxt.text!.isEmpty {
            alert(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("fill in all fields", comment: ""))
            return
        }
        
        // if image is not uploaded
        if !isImgPicked {
            alert(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("image not uploaded", comment: ""))
            return
        }
        
        // change send status to yes
        didSend = true
        
        let object = PFObject(className: "themes")
        
        // generate uuid for the new post
        let themeuuid = UUID().uuidString
        object["themeuuid"] = themeuuid
        
        // convert theme image
        let themeData = UIImageJPEGRepresentation(themeImg.image!, 0.5)
        let themeFile = PFFile(name: "theme.jpg", data: themeData!)
        object["theme"] = themeFile

        object["username"] = PFUser.current()?.username
        
        object["adjective"] = adjBtn.titleLabel?.text
        object["noun"] = nounTxt.text!
        object["category"] = categoryBtn.titleLabel?.text
        object["title"] = "\(adjBtn.titleLabel!.text!) \(nounTxt.text!)"
        
        object["totalPosts"] = 0
        
        object["hashtags"] = "#\(adjBtn.titleLabel!.text!) #\(categoryBtn.titleLabel!.text!) #\(nounTxt.text!)"
        
        object.saveInBackground { (success, error) in
            if success {
                // send notification with name "uploaded" to postIdeaVC to show newVC
                NotificationCenter.default.post(name: NSNotification.Name.init("themeUploaded"), object: nil)
                
                // reset text field
                self.nounTxt.text = ""
                
                // dismiss
                self.navigationController?.popViewController(animated: true)
            } else {
                print(error!.localizedDescription)
            }
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

extension postThemeVC: PickerViewKeyboardDelegate {
    func titlesOfPickerViewKeyboard(sender: PickerViewKeyboard) -> Array<String> {
        if sender == adjBtn {
            return adjs
        } else if sender == categoryBtn {
            return categories
        } else {
            return langs
        }
    }
    func initSelectedRow(sender: PickerViewKeyboard) -> Int {
        if sender == adjBtn {
            return adjs.count
        } else if sender == categoryBtn {
            return categories.count
        } else {
            return langs.count
        }
    }
    func didDone(sender: PickerViewKeyboard, selectedData: String) {
        if sender == adjBtn {
            adjBtn.setTitle(selectedData, for: UIControlState.normal)
            // update title label
            titleLbl.text = "\(selectedData) \(nounTxt.text!)"
            adjBtn.resignFirstResponder()
        } else if sender == categoryBtn {
            categoryBtn.setTitle(selectedData, for: UIControlState.normal)
            categoryBtn.resignFirstResponder()
        } else {
            langBtn.setTitle(selectedData, for: UIControlState.normal)
            langBtn.resignFirstResponder()
        }
        
        // disable send button if not everything is filled, enable otherwise
        if nounTxt.text!.isEmpty {
            
            // disable
            sendBtn.backgroundColor = UIColor.lightGray
            sendBtn.isEnabled = false
        } else {
            
            // enable
            sendBtn.backgroundColor = customColorYellow
            sendBtn.isEnabled = true
        }
    }
    func didCancel(sender: PickerViewKeyboard) {
        if sender == adjBtn {
            adjBtn.resignFirstResponder()
        } else if sender == categoryBtn {
            categoryBtn.resignFirstResponder()
        } else {
            langBtn.resignFirstResponder()
        }
    }
}
