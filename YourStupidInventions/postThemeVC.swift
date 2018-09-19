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
    
    @IBOutlet weak var fileImg: UIImageView!
    @IBOutlet weak var uploadLbl: UILabel!
    
    @IBOutlet weak var nounLbl: UILabel!
    @IBOutlet weak var nounTxt: UITextField!
    
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var categoryBtn: PickerViewKeyboard!
    
    @IBOutlet weak var langLbl: UILabel!
    @IBOutlet weak var langBtn: PickerViewKeyboard!
    
    @IBOutlet weak var categoryBtnTri: UIButton!
    @IBOutlet weak var langBtnTri: UIButton!
    
    @IBOutlet weak var sendBtn: UIButton!
    
    var ActivityIndicator: UIActivityIndicatorView!
    
    
    // send status to avoid sending twice
    var didSend = false
    
    // image picker status
    var isImgPicked = false
    
    // pickerView and pickerData
    var categories = [NSLocalizedString("Appliance", comment: ""),
                      NSLocalizedString("Software", comment: ""),
                      NSLocalizedString("Food", comment: ""),
                      NSLocalizedString("Entertainment", comment: ""),
                      NSLocalizedString("Sports", comment: ""),
                      NSLocalizedString("Others", comment: "")]
    
    var categories_en = ["Appliance",
                         "Software",
                         "Food",
                         "Entertainment",
                         "Sports",
                         "Others"]
    
    var langs = [NSLocalizedString("English", comment: ""),
                 NSLocalizedString("Japanese", comment: "")/*,
                 NSLocalizedString("Chinese", comment: "")*/]
    
    // Done button on keyboard
    var kbToolBar: UIToolbar!
    
    // scroll view
    @IBOutlet weak var scrollView: UIScrollView!

    // reset default height
    var scrollViewHeight: CGFloat = 0
    
    // keyboard frame size
    var keyboard = CGRect()
    
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
        
        // done button on keyboard
        kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default
        kbToolBar.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneButtonTapped))
        kbToolBar.items = [spacer, doneButton]
        nounTxt.inputAccessoryView = kbToolBar
        
        // Activity Indicator
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        ActivityIndicator.center = self.view.center
        ActivityIndicator.hidesWhenStopped = true
        ActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(ActivityIndicator)
        
        // scrollView frame size
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        scrollView.contentSize.height = self.view.frame.size.height
        scrollViewHeight = scrollView.frame.size.height
        
        // check notifications if keyboard is shown or not
        NotificationCenter.default.addObserver(self, selector: #selector(self.showKeyboard), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideKeyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        // editingChanged notification to call textFieldDidChange func
        nounTxt.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        
        // enable UITextView functions
        nounTxt.delegate = self
        
        categoryBtn.delegate = self
        langBtn.delegate = self
        
        
        // call alignment fun
        alignment()
    }
    
    
    // tapped done button on keyboard
    @objc func doneButtonTapped() {
        self.view.endEditing(true)
    }

    
    // show keyboard func
    @objc func showKeyboard(notification: NSNotification) {
        
        // define keyboard size
        keyboard = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue)!
        
        // move up UI
        UIView.animate(withDuration: 0.4) {
            // shrink scrollView size
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.height
            
            // scroll to bottom
            var offset = self.scrollView.contentOffset
            offset.y =  self.scrollViewHeight - self.sendBtn.frame.origin.y - self.keyboard.height + 40
            self.scrollView.setContentOffset(offset, animated: true)
        }
        
        
    }
    
    
    // hide keyboard func
    @objc func hideKeyboard(notification: NSNotification){
        self.view.endEditing(true)
        // move down UI
        UIView.animate(withDuration: 0.4) {
            self.scrollView.frame.size.height = self.scrollViewHeight
        }
    }
    
    // go back to the previous view
    @objc func back(sender: UITabBarItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // alignment func
    func alignment() {
        
        let width = self.view.frame.size.width
        let themeImgWidth = width - 20
        let themeImgHeight = themeImgWidth / 16 * 9
        
        titleLbl.frame = CGRect(x: 10, y: 10, width: width - 20, height: 90)
        themeImg.frame = CGRect(x: 10, y: titleLbl.frame.origin.y + titleLbl.frame.size.height, width: themeImgWidth, height: themeImgHeight)
        
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        themeImg.translatesAutoresizingMaskIntoConstraints = false
        nounLbl.translatesAutoresizingMaskIntoConstraints = false
        nounTxt.translatesAutoresizingMaskIntoConstraints = false
        categoryLbl.translatesAutoresizingMaskIntoConstraints = false
        categoryBtn.translatesAutoresizingMaskIntoConstraints = false
        categoryBtnTri.translatesAutoresizingMaskIntoConstraints = false
        langLbl.translatesAutoresizingMaskIntoConstraints = false
        langBtn.translatesAutoresizingMaskIntoConstraints = false
        langBtnTri.translatesAutoresizingMaskIntoConstraints = false
        sendBtn.translatesAutoresizingMaskIntoConstraints = false
        fileImg.translatesAutoresizingMaskIntoConstraints = false
        uploadLbl.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[title]-10-[theme(\(themeImgHeight))]-10-[nounLbl(30)]-10-[categoryLbl(30)]-10-[langLbl(30)]-10-[send(30)]-10-|",
            options: [], metrics: nil, views: ["title": titleLbl, "theme": themeImg, "nounLbl": nounLbl, "categoryLbl": categoryLbl, "langLbl": langLbl, "send": sendBtn]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[theme]-10-[nounTxt(30)]-10-[categoryBtn(30)]-10-[langBtn(30)]",
            options: [], metrics: nil, views: ["theme": themeImg, "nounTxt": nounTxt, "categoryBtn": categoryBtn, "langBtn": langBtn]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[theme]-(\(-30 - themeImgHeight / 2))-[fileImg(50)]-0-[uploadLbl]",
            options: [], metrics: nil, views: ["theme": themeImg, "fileImg": fileImg, "uploadLbl": uploadLbl]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[nounTxt]-18-[categoryBtnTri(14)]-26-[langBtnTri(14)]",
            options: [], metrics: nil, views: ["nounTxt": nounTxt, "categoryBtnTri": categoryBtnTri, "langBtnTri": langBtnTri]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[title]-10-|",
            options: [], metrics: nil, views: ["title": titleLbl]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[theme(\(themeImgWidth))]-10-|",
            options: [], metrics: nil, views: ["theme": themeImg]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[theme]-(\(-25 - themeImgWidth / 2))-[fileImg(50)]",
            options: [], metrics: nil, views: ["theme": themeImg, "fileImg": fileImg]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[uploadLbl]-10-|",
            options: [], metrics: nil, views: ["uploadLbl": uploadLbl]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[nounLbl]-10-[nounTxt(\(width * 0.7))]-10-|",
            options: [], metrics: nil, views: ["nounLbl": nounLbl, "nounTxt": nounTxt]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[categoryLbl]-10-[categoryBtn(\(width * 0.7))]-10-|",
            options: [], metrics: nil, views: ["categoryLbl": categoryLbl, "categoryBtn": categoryBtn]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[langLbl]-10-[langBtn(\(width * 0.7))]-10-|",
            options: [], metrics: nil, views: ["langLbl": langLbl, "langBtn": langBtn]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[categoryBtnTri(16)]-(-30)-[categoryBtn]",
            options: [], metrics: nil, views: ["categoryBtnTri": categoryBtnTri, "categoryBtn": categoryBtn]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[langBtnTri(16)]-(-30)-[langBtn]",
            options: [], metrics: nil, views: ["langBtnTri": langBtnTri, "langBtn": langBtn]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[send]-10-|",
            options: [], metrics: nil, views: ["send": sendBtn]))
        
        
        sendBtn.layer.cornerRadius = 5
        sendBtn.clipsToBounds = true
        
        // disable send button untill everything is filled
        sendBtn.backgroundColor = UIColor.lightGray
        sendBtn.isEnabled = false
        
        nounLbl.text = NSLocalizedString("noun", comment: "")
        categoryLbl.text = NSLocalizedString("category", comment: "")
        langLbl.text = NSLocalizedString("language", comment: "")

        categoryBtn.backgroundColor = .clear
        categoryBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        categoryBtn.layer.cornerRadius = 5
        categoryBtn.layer.borderWidth = 1
        categoryBtn.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        categoryBtnTri.isUserInteractionEnabled = false
        
        langBtn.backgroundColor = .clear
        langBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        langBtn.layer.cornerRadius = 5
        langBtn.layer.borderWidth = 1
        langBtn.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        langBtnTri.isUserInteractionEnabled = false
        
        nounTxt.placeholder = NSLocalizedString("Type noun", comment: "")
        sendBtn.setTitle(NSLocalizedString("Publish", comment: ""), for: UIControlState.normal)
        
        // set post language as default language
        if postIdeaPrimaryLang == "en" {
            langBtn.setTitle(NSLocalizedString("English", comment: ""), for: UIControlState.normal)
        } else if postIdeaPrimaryLang == "jp" {
            langBtn.setTitle(NSLocalizedString("Japanese", comment: ""), for: UIControlState.normal)
        } else {
            langBtn.setTitle(NSLocalizedString("Chinese", comment: ""), for: UIControlState.normal)
        }
        
        // set the first row as default
        categoryBtn.setTitle(NSLocalizedString(categories[0], comment: ""), for: UIControlState.normal)
    
        
        // set title label
        if postIdeaPrimaryLang == "en "{
            titleLbl.text = "\(NSLocalizedString("what is in en", comment: "")) \(NSLocalizedString("innovative in en", comment: "")) \(nounTxt.text!)"
        } else if postIdeaPrimaryLang == "jp" {
            titleLbl.text = "\(NSLocalizedString("what is in jp", comment: "")) \(NSLocalizedString("innovative in jp", comment: "")) \(nounTxt.text!)"
        } else {
            titleLbl.text = "\(NSLocalizedString("what is in ch", comment: "")) \(NSLocalizedString("innovative in ch", comment: "")) \(nounTxt.text!)"
        }
        
        let titleLblFrame = titleLbl.frame
        titleLbl.numberOfLines = 3
        titleLbl.sizeToFit()
        titleLbl.frame = titleLblFrame
        
        uploadLbl.text = NSLocalizedString("tap to upload an image", comment: "")
        uploadLbl.textAlignment = .center
    
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
        imageCropVC.avoidEmptySpaceAroundImage = true
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
        
        // hide tap to upload image and label
        fileImg.isHidden = true
        uploadLbl.isHidden = true
    }

    
    /* RSKImageCropViewControllerDelegate END */
    
    // PICKER VIEW METHODS
    // picker comp number
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    /* UITextFieldDelegate */
    
    // changed textField
    @objc func textFieldDidChange(_ textField: UITextField) {
        
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
        
        // update title label
        if langBtn.titleLabel?.text == NSLocalizedString("English", comment: "") {
            titleLbl.text = "\(NSLocalizedString("what is in en", comment: "")) \(NSLocalizedString("innovative in en", comment: "")) \(nounTxt.text!)"
        } else if langBtn.titleLabel?.text == NSLocalizedString("Japanese", comment: "") {
            titleLbl.text = "\(NSLocalizedString("what is in jp", comment: "")) \(NSLocalizedString("innovative in jp", comment: "")) \(nounTxt.text!)"
        } else {
            titleLbl.text = "\(NSLocalizedString("what is in ch", comment: "")) \(NSLocalizedString("innovative in ch", comment: "")) \(nounTxt.text!)"
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
        
        // start indicator animation
        ActivityIndicator.startAnimating()
        
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
    
        object["noun"] = nounTxt.text!
        object["category"] = categoryBtn.layer.value(forKey: "category") as! String
        object["adjective"] = NSLocalizedString("innovative in en", comment: "")
        
        if langBtn.titleLabel?.text == NSLocalizedString("English", comment: "") {
            object["title"] = "\(NSLocalizedString("innovative in en", comment: "")) \(nounTxt.text!)"
        } else if langBtn.titleLabel?.text == NSLocalizedString("Japanese", comment: "") {
            object["title"] = "\(NSLocalizedString("innovative in jp", comment: "")) \(nounTxt.text!)"
        } else {
            object["title"] = "\(NSLocalizedString("innovative in ch", comment: "")) \(nounTxt.text!)"
        }
        
        if langBtn.titleLabel!.text! == NSLocalizedString("en", comment: "") {
            object["language"] = "en"
        } else if langBtn.titleLabel!.text! == NSLocalizedString("jp", comment: "") {
            object["language"] = "jp"
        } else {
            object["language"] = "ch"
        }
        
        object["totalPosts"] = 0
        
        object["hashtags"] = ""
        
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

extension postThemeVC: PickerViewKeyboardDelegate {
    func titlesOfPickerViewKeyboard(sender: PickerViewKeyboard) -> Array<String> {
        if sender == categoryBtn {
            return categories
        } else {
            return langs
        }
    }
    func initSelectedRow(sender: PickerViewKeyboard) -> Int {
        if sender == categoryBtn {
            return categories.count
        } else {
            return langs.count
        }
    }
    func didDone(sender: PickerViewKeyboard, selectedData: String, selectedIndex: Int) {
        
        if sender == categoryBtn {
            categoryBtn.setTitle(selectedData, for: UIControlState.normal)
            categoryBtn.layer.setValue(categories_en[selectedIndex], forKey: "category")
            categoryBtn.resignFirstResponder()
        } else {
            langBtn.setTitle(selectedData, for: UIControlState.normal)
            langBtn.resignFirstResponder()
            
            // update title label
            if selectedData == NSLocalizedString("English", comment: "") {
                titleLbl.text = "\(NSLocalizedString("what is in en", comment: "")) \(NSLocalizedString("innovative in en", comment: "")) \(nounTxt.text!)"
            } else if selectedData == NSLocalizedString("Japanese", comment: "") {
                titleLbl.text = "\(NSLocalizedString("what is in jp", comment: "")) \(NSLocalizedString("innovative in jp", comment: "")) \(nounTxt.text!)"
            } else {
                titleLbl.text = "\(NSLocalizedString("what is in ch", comment: "")) \(NSLocalizedString("innovative in ch", comment: "")) \(nounTxt.text!)"
            }
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
        if sender == categoryBtn {
            categoryBtn.resignFirstResponder()
        } else {
            langBtn.resignFirstResponder()
        }
    }
}
