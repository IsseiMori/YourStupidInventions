//
//  commentVC.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/26/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse

// global variables to store the post data
var commentuuid = [String]()
var commentowner = [String]()

class commentVC: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // UI objects
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTxt: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    var refresher = UIRefreshControl()
    var placeholderLbl = UILabel()
    
    // values for resting UI to default
    var tableViewHeight: CGFloat = 0
    var commentY: CGFloat = 0
    var commentHeight: CGFloat = 0
    
    // variable to hold keyboard frame
    var keyboard = CGRect()
    
    // arrays to hold data from server
    var commentArray = [String]()
    var usernameArray = [String]()
    var dateArray = [Date?]()
    
    
    // page size
    var page: Int = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title at the top
        self.navigationItem.title = "Comments"

        // present commentHeaderCell as header
        let headerCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "commentHeaderCell") as! commentHeaderCell
        let headerView: UIView = headerCell.contentView
        tableView.tableHeaderView = headerView
        
        // receive show and hide keyboard notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        // tap to start editing
        let commentTap = UITapGestureRecognizer(target: self, action: #selector(self.showKeyboardTap))
        commentTap.numberOfTapsRequired = 1
        commentTxt.isUserInteractionEnabled = true
        commentTxt.addGestureRecognizer(commentTap)
        
        // declare hide keyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // set delegate to use tableView and textView functions
        commentTxt.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // create placeholder label programmatically
        let placeholderX: CGFloat = self.view.frame.size.width / 75
        let placeholderY: CGFloat = 0
        let placeholderWidth: CGFloat = commentTxt.bounds.width - placeholderX
        let placeholderHeight: CGFloat = commentTxt.bounds.height
        let placeholderFontSize = self.view.frame.size.width / 25
        
        placeholderLbl.frame = CGRect(x: placeholderX, y: placeholderY, width: placeholderWidth, height: placeholderHeight)
        placeholderLbl.text = "Enter text..."
        placeholderLbl.font = UIFont(name: "HelveticaNeue", size: placeholderFontSize)
        placeholderLbl.textColor = UIColor.lightGray
        placeholderLbl.textAlignment = NSTextAlignment.left
        commentTxt.addSubview(placeholderLbl)
        
        // call alignment func
        alignment()
        
        // load comments
        loadComments()
    }
    
    
    // show keyboard if clicked commentTxt
    @objc func showKeyboardTap(recognizer: UITapGestureRecognizer) {
        
        // open keyboard
        commentTxt.becomeFirstResponder()
    }
    
    
    // hide keyboard if tapped
    @objc func hideKeyboardTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    // move up UI when keyboard shows up
    @objc func keyboardWillShow(notification: Notification) {
        
        
        // define keyboard frame size
        keyboard = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
        
        // move up UI
        UIView.animate(withDuration: 0.4) {
            
            self.tableView.frame.size.height = self.tableViewHeight - self.keyboard.height - self.commentTxt.frame.size.height + self.commentHeight
            
            self.commentTxt.frame.origin.y = self.commentY - self.keyboard.height - self.commentTxt.frame.size.height + self.commentHeight
            self.sendBtn.frame.origin.y = self.commentTxt.frame.origin.y
            
            // scroll the height of keyboard
            self.tableView.setContentOffset(CGPoint(x: 0, y: self.keyboard.height), animated: false)
            
        }
        
    }
    
    
    // move down UI when keyboard hides
    @objc func keyboardWillHide(notification: Notification) {
        
        // move down UI
        self.tableView.frame.size.height = self.tableViewHeight
        self.commentTxt.frame.origin.y = self.commentY
        self.sendBtn.frame.origin.y = self.commentY
    }
    
    
    // while writing
    func textViewDidChange(_ textView: UITextView) {
        
        // disable button if entered no text
        let spacing = NSCharacterSet.whitespacesAndNewlines
        
        // entered something
        if !commentTxt.text.trimmingCharacters(in: spacing).isEmpty {
            sendBtn.isEnabled = true
            placeholderLbl.isHidden = true
            
            // text is not entered
        } else {
            sendBtn.isEnabled = false
            placeholderLbl.isHidden = false
        }
        
        // + paragraph
        if textView.contentSize.height > textView.frame.size.height && textView.frame.height < 130 {
            
            // define difference to add
            let difference = textView.contentSize.height - textView.frame.size.height
            
            // redefine frame of commentTxt
            textView.frame.origin.y = textView.frame.origin.y - difference
            textView.frame.size.height = textView.contentSize.height
            
            // move up tableView
            if textView.contentSize.height + keyboard.height + commentY >= tableView.frame.size.height {
                tableView.frame.size.height = tableView.frame.size.height - difference
            }
        }
            
            // - paragraph
        else if textView.contentSize.height < textView.frame.size.height {
            
            // define difference to subtract
            let difference = textView.frame.size.height - textView.contentSize.height
            
            // redefine frame of commentTxt
            textView.frame.origin.y = textView.frame.origin.y + difference
            textView.frame.size.height = textView.contentSize.height
            
            // move down tableView
            if textView.contentSize.height + keyboard.height + commentY > tableView.frame.size.height {
                tableView.frame.size.height = tableView.frame.size.height + difference
            }
        }
    }
    
    
    // alignment func
    func alignment() {
        
        // alignment
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        tableView.frame = CGRect(x: 0, y: 0, width: width, height: height / 1.096 - self.navigationController!.navigationBar.frame.size.height - 20)
        tableView.estimatedRowHeight = width / 5.333
        tableView.rowHeight = UITableViewAutomaticDimension
        
        commentTxt.frame = CGRect(x: 10, y: tableView.frame.size.height + height / 56.8, width: width / 1.306, height: 33)
        commentTxt.layer.cornerRadius = commentTxt.frame.size.width / 50
        
        sendBtn.frame = CGRect(x: commentTxt.frame.origin.x + commentTxt.frame.size.width + width / 32, y: commentTxt.frame.origin.y, width: width - (commentTxt.frame.origin.x + commentTxt.frame.size.width) - (width / 32) * 2, height: commentTxt.frame.size.height)
        
        // assign resting values
        tableViewHeight = tableView.frame.size.height
        commentHeight = commentTxt.frame.size.height
        commentY = commentTxt.frame.origin.y
    }

    
    // preload func
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    // post laod func
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    // load comments
    func loadComments() {
        
        // get comments to this post
        let query = PFQuery(className: "comments")
        query.whereKey("to", equalTo: commentuuid.last!)
        query.limit = page
        query.addAscendingOrder("createdAt")
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                
                // clean up arrays
                self.commentArray.removeAll(keepingCapacity: false)
                self.usernameArray.removeAll(keepingCapacity: false)
                self.dateArray.removeAll(keepingCapacity: false)
                
                // store comments in arrays
                for object in objects! {
                    self.commentArray.append(object.object(forKey: "comment") as! String)
                    self.usernameArray.append(object.object(forKey: "username") as! String)
                    self.dateArray.append(object.createdAt)
                    self.tableView.reloadData()
                    
                    // scroll to bottom
                    self.tableView.scrollToRow(at: IndexPath(row: self.commentArray.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }

    
    // number of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    
    // automatic cell height
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // cell config
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! commentCell
        
        // display comment and username
        cell.commentLbl.text = commentArray[indexPath.row]
        cell.usernameBtn.setTitle(usernameArray[indexPath.row], for: UIControlState.normal)
        
        cell.commentLbl.numberOfLines = 5
        
        // calculate date
        let from = dateArray[indexPath.row]
        let now = Date()
        let components: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
        let difference = (Calendar.current as NSCalendar).components(components, from: from!, to: now, options: [])
        
        if difference.second! <= 0 {
            cell.dateLbl.text = "now"
        }
        if difference.second! > 0 && difference.minute! == 0 {
            cell.dateLbl.text = "\(difference.second!)s. ago"
        }
        if difference.minute! > 0 && difference.hour! == 0 {
            cell.dateLbl.text = "\(difference.minute!)m. ago"
        }
        if difference.hour! > 0 && difference.day! == 0 {
            cell.dateLbl.text = "\(difference.hour!)h. ago"
        }
        if difference.day! > 0 && difference.weekOfMonth! == 0 {
            cell.dateLbl.text = "\(difference.day!)d. ago"
        }
        if difference.weekOfMonth! > 0 {
            cell.dateLbl.text = "\(difference.weekOfMonth!)w. ago"
        }
        
        return cell
    }
    
    
    // clicked send button
    @IBAction func sendBtn_clicked(_ sender: Any) {
        
        // STEP 1: add row in tableView
        usernameArray.append(PFUser.current()!.username!)
        commentArray.append(commentTxt.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        
        dateArray.append(Date())
        tableView.reloadData()
        
        // STEP 2: send comment to server
        let commentObj = PFObject(className: "comments")
        commentObj["username"] = PFUser.current()?.username
        commentObj["to"] = commentuuid.last!
        commentObj["comment"] = commentTxt.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        commentObj.saveEventually()
        
        
        /*
        // STEP 3: send #hashtag to server
        let words: [String] = commentTxt.text!.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        
        // define taged word
        for var word in words {
            
            // save #hashtag in server
            if word.hasPrefix("#") {
                
                // cut symbols
                word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
                word = word.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                
                let wordObj = PFObject(className: "hashtags")
                wordObj["to"] = commentuuid.last!
                wordObj["by"] = PFUser.current()?.username
                wordObj["hashtag"] = word.lowercased()
                wordObj["comment"] = commentTxt.text
                wordObj.saveInBackground { (success, error) in
                    if success {
                        // print("hashtag \(word) is created")
                    } else {
                        print(error!.localizedDescription)
                    }
                }
                
            }
        }*/
        
        
        
        // STEP 5: send notification as comment
        if commentowner.last != PFUser.current()?.username {
            
            let newsObj = PFObject(className: "news")
            newsObj["by"] = PFUser.current()?.username
            newsObj["to"] = commentowner.last!
            // newsObj["ava"] = PFUser.current()?.object(forKey: "ava") as! PFFile
            newsObj["owner"] = commentowner.last!
            newsObj["uuid"] = commentuuid.last!
            newsObj["type"] = "comment"
            newsObj["checked"] = "no"
            newsObj.saveEventually()
        }
        
        
        
        // scroll to bottom
        self.tableView.scrollToRow(at: IndexPath(row: commentArray.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
        
        // STEP 6: reset UI
        sendBtn.isEnabled = false
        placeholderLbl.isHidden = false
        commentTxt.text = ""
        commentTxt.frame.size.height = commentHeight
        commentTxt.frame.origin.y = sendBtn.frame.origin.y
        tableView.frame.size.height = self.tableViewHeight - self.keyboard.height - self.commentTxt.frame.size.height + self.commentHeight
    }
    

}
