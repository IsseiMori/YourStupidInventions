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

class postThemeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // UI objects
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var themeImg: UIImageView!
    @IBOutlet weak var adjTxt: UITextField!
    @IBOutlet weak var categoryTxt: UITextField!
    @IBOutlet weak var nounTxt: UITextField!
    
    @IBOutlet weak var sendBtn: UIButton!
    
    // send status to avoid sending twice
    var didSend = false
    
    // pickerView and pickerData
    var adjPicker: UIPickerView!
    var adjs = ["Innovative", "Unexpected", "Future"]
    var categoryPicker: UIPickerView!
    var categories = ["Appliance", "Software", "Food", "Entertainment", "Sports", "Others"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Post Theme"
        
        // create adjective picker
        adjPicker = UIPickerView()
        adjPicker.dataSource = self
        adjPicker.delegate = self
        adjPicker.backgroundColor = UIColor.groupTableViewBackground
        adjPicker.showsSelectionIndicator = true
        adjTxt.inputView = adjPicker
        
        // create category picker
        categoryPicker = UIPickerView()
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        categoryPicker.backgroundColor = UIColor.groupTableViewBackground
        categoryPicker.showsSelectionIndicator = true
        categoryTxt.inputView = categoryPicker

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
        
        adjTxt.frame = CGRect(x: 10, y: themeImg.frame.origin.y + themeImgHeight + 10, width: width * 0.45, height: 30)
        categoryTxt.frame = CGRect(x: width - 10 - width * 0.45, y: themeImg.frame.origin.y + themeImgHeight + 10, width: width * 0.45, height: 30)
        
        nounTxt.frame = CGRect(x: 10, y: adjTxt.frame.origin.y + adjTxt.frame.size.height + 10, width: width - 20, height: 30)
        sendBtn.frame = CGRect(x: 10, y: nounTxt.frame.origin.y + nounTxt.frame.size.height + 10, width: width - 20, height: 30)
        
        sendBtn.layer.cornerRadius = 5
        sendBtn.clipsToBounds = true
        
        // disable send button untill everything is filled
        sendBtn.backgroundColor = UIColor.lightGray
        sendBtn.isEnabled = false
        
        //adjTxt.edi
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
    }
    
    /* RSKImageCropViewControllerDelegate END */
    
    // PICKER VIEW METHODS
    // picker comp number
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /* UIPickerViewDataSource */
    
    // picker text number
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == adjPicker {
            return 3
        } else {
            return 6
        }
    }
    
    // picker text config
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == adjPicker {
            return adjs[row]
        } else {
            return categories[row]
        }
    }
    
    // picker selected a row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == adjPicker {
            adjTxt.text = adjs[row]
        } else {
            categoryTxt.text = categories[row]
        }
        
        titleLbl.text = "\(adjTxt.text!) \(nounTxt.text!)"
        
        self.view.endEditing(true)
    }
    
    /* UIPickerViewDataSource END */
    
    /* UITextFieldDelegate */
    
    // finished editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        // update title label
        titleLbl.text = "\(adjTxt.text!) \(nounTxt.text!)"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // if entered return, dismiss keyboard
        if string == "\n" {
            nounTxt.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
        if (adjTxt.text?.isEmpty)! || (categoryTxt.text?.isEmpty)! || (nounTxt.text?.isEmpty)! {
            // disable send button if not everything is filled
            sendBtn.backgroundColor = UIColor.lightGray
            sendBtn.isEnabled = false
        } else {
            // enable send button if everything is filled
            sendBtn.backgroundColor = customColorYellow
            sendBtn.isEnabled = true
        }
    }
    
    /* UITextFieldDelegate END*/
    
    
    // clicked send button
    @IBAction func sendBtn_clicked(_ sender: Any) {
        
        // if status is already sent, return
        if didSend {
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
        
        object["adjective"] = adjTxt.text!
        object["noun"] = nounTxt.text!
        object["category"] = categoryTxt.text!
        object["title"] = "\(adjTxt.text!) \(nounTxt.text!)"
        
        object["totalPosts"] = 0
        
        object["hashtags"] = "#\(adjTxt.text!) #\(categoryTxt.text!) #\(nounTxt.text!)"
        
        object.saveInBackground { (success, error) in
            if success {
                // send notification with name "uploaded" to postIdeaVC to show newVC
                NotificationCenter.default.post(name: NSNotification.Name.init("themeUploaded"), object: nil)
                
                // reset text field
                self.adjTxt.text = ""
                self.categoryTxt.text = ""
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
