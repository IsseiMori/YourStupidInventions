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
    
    // global variable
    var likeLbl: UILabel!
    
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
    
    // Done button on keyboard
    var kbToolBar: UIToolbar!
    
    // header cell
    var header: commentHeaderCell!
    
    // number of likeBtn tap
    var didLike: Int = 0
    
    // page size
    var page: Int = 10
    
    // # of posts to load at each loadMore()
    var pageLimit: Int = 10
    
    // loading status to avoid keep loading
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title at the top
        self.navigationItem.title = NSLocalizedString("Comments", comment: "")
        
        // new back button
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.back))
        self.navigationItem.leftBarButtonItem = backBtn
        
        // swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.back))
        backSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(backSwipe)
        
        // more button to delete or complain
        // delete if to enable delete post func
        //if commentowner.last! != PFUser.current()?.username {
            let moreBtn = UIBarButtonItem(image: UIImage(named: "moreNav.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.more))
            self.navigationItem.rightBarButtonItem = moreBtn
        //}

        // present commentHeaderCell as header
        self.header = tableView.dequeueReusableCell(withIdentifier: "commentHeaderCell") as! commentHeaderCell
        self.header.delegate = self
        //let headerView: UIView = headerCell.contentView
        tableView.tableHeaderView = header.contentView
        
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
        
        // disable send button until it has some comment
        sendBtn.isEnabled = false
        
        // set delegate to use tableView and textView functions
        commentTxt.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        // pull to refresh
        self.refresher.addTarget(self, action: #selector(self.loadComments), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(self.refresher)
        
        // done button on keyboard
        kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default
        kbToolBar.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneButtonTapped))
        kbToolBar.items = [spacer, doneButton]
        commentTxt.inputAccessoryView = kbToolBar
        
        // create placeholder label programmatically
        let placeholderX: CGFloat = self.view.frame.size.width / 75
        let placeholderY: CGFloat = 0
        let placeholderWidth: CGFloat = commentTxt.bounds.width - placeholderX
        let placeholderHeight: CGFloat = commentTxt.bounds.height
        let placeholderFontSize = self.view.frame.size.width / 25
        
        placeholderLbl.frame = CGRect(x: placeholderX, y: placeholderY, width: placeholderWidth, height: placeholderHeight)
        placeholderLbl.text = NSLocalizedString("Enter text", comment: "")
        placeholderLbl.font = UIFont(name: "HelveticaNeue", size: placeholderFontSize)
        placeholderLbl.textColor = UIColor.lightGray
        placeholderLbl.textAlignment = NSTextAlignment.left
        commentTxt.addSubview(placeholderLbl)
        
        sendBtn.setTitle(NSLocalizedString("Send", comment: ""), for: UIControlState.normal)
        
        // call alignment func
        alignment()
        
        // load comments
        loadComments()
    }
    
    // tapped done button on keyboard
    @objc func doneButtonTapped() {
        self.view.endEditing(true)
    }
    
    // show keyboard if clicked commentTxt
    @objc func showKeyboardTap(recognizer: UITapGestureRecognizer) {
        
        if isLoggedIn {
            
            // open keyboard
            commentTxt.becomeFirstResponder()
        } else {
            
            alert(title: NSLocalizedString("please sign in", comment: ""), message: NSLocalizedString("sign in from profile page", comment: ""))
        }
        
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

    
    // load comments
    @objc func loadComments() {
        
        // set loading status to processing
        isLoading = true
        
        // get comments to this post
        let query = PFQuery(className: "comments")
        query.whereKey("to", equalTo: commentuuid.last!)
        query.limit = self.pageLimit
        query.addAscendingOrder("createdAt")
        print("commentVC loadComments")
        processQuery(query: query)
    }
    
    
    // scrolled down
    // isAtBottom to avoid keep requesting query
    // has to get out the loadMore area once to request another
    var isAtBottom: Bool = false
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - self.view.frame.size.height
        let distanceToBottom = maximumOffset - currentOffsetY
        
        if distanceToBottom < 50 && maximumOffset > 50{
            
            // don't load more if still loading
            // if this is the first time to reach the bottom, loadMore and set isAtBottom to true
            if !isLoading && !isAtBottom{
                isAtBottom = true
                loadMore()
            }
        } else {
            isAtBottom = false
        }
    }
    
    // pagination
    @objc func loadMore() {
        
        // set loading status to processing
        isLoading = true
        
       
        // get comments to this post
        let query = PFQuery(className: "comments")
        query.whereKey("to", equalTo: commentuuid.last!)
        query.skip = self.page
        query.limit = self.pageLimit
        
        self.page = self.page + self.pageLimit
        
        query.addAscendingOrder("createdAt")
        print("commentVC loadmore")
        self.processQuery(query: query)

    }
    
    
    // process query and store data in array
    func processQuery(query: PFQuery<PFObject>) {
 
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                
                // if no more object is found, end loadmore process
                if objects?.count == 0 {
                    return
                }
                
                // store comments in arrays
                for object in objects! {
                    
                    // check empty
                    if (object.object(forKey: "comment") != nil &&
                        object.object(forKey: "username") != nil
                        ) {
                    
                        self.commentArray.append(object.object(forKey: "comment") as! String)
                        self.usernameArray.append(object.object(forKey: "username") as! String)
                        self.dateArray.append(object.createdAt)
                    }
                }
                
                // reload tableView and end refresh animation
                self.tableView.reloadData()
                self.refresher.endRefreshing()
                
                
                // set loading status to finished if loaded something
                if !(objects?.isEmpty)! {
                    self.isLoading = false
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
        
        // assign indexes of buttons
        cell.usernameBtn.layer.setValue(indexPath, forKey: "index")
        
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
            print("commentVC save notification")
        }
        
        
        
        // scroll to bottom
        self.tableView.scrollToRow(at: IndexPath(row: commentArray.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
        
        // STEP 6: reset UI
        sendBtn.isEnabled = false
        placeholderLbl.isHidden = false
        commentTxt.text = ""
        commentTxt.frame.size.height = commentHeight
        commentTxt.frame.origin.y = sendBtn.frame.origin.y
        tableView.frame.size.height = self.tableViewHeight
    }
    
    
    // clicked usename button
    @IBAction func usernameBtn_clicked(_ sender: Any) {
        // call index of current button
        let button = sender as! UIButton
        
        // if user tapped on his username go home, otherwise go guest
        if button.titleLabel?.text == PFUser.current()?.username {
            let home = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! homeVC
            self.navigationController?.pushViewController(home, animated: true)
        } else {
            guestname.append((button.titleLabel?.text)!)
            let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestVC") as! guestVC
            self.navigationController?.pushViewController(guest, animated: true)
        }
    }
    
    
    // clicked like button
    // can't reload only header so keep it global variable and resubstitute when updated
    @IBAction func likeBtn_clicked(_ sender: Any) {
        
        if isLoggedIn {
            // change background image
            if header.likeBtn.titleLabel?.text != "like" {
                header.likeBtn.setTitle("like", for: UIControlState.normal)
                header.likeBtn.setBackgroundImage(UIImage(named: "like.png"), for: UIControlState.normal)
            }
            
            // increment likeLbl
            header.likeLbl.text = String(Int(header.likeLbl.text!)! + 1)
            
            // increment didLike
            didLike = didLike + 1
            
            // present updated header
            tableView.tableHeaderView = header.contentView
        } else {
            alert(title: "Please sing in", message: "Sign in from home page to like this idea.")
        }
        
    }
    
    
    // preload func
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        
        // reset like count
        didLike = 0
    }
    
    
    // post laod func
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
        // save number of likeBtn taps to server
        if didLike != 0 && isLoggedIn {
            
            // update total likes in each post
            let query = PFQuery(className: "posts")
            query.whereKey("uuid", equalTo: header.uuidLbl.text!)
            print("commentVC send like count")
            query.getFirstObjectInBackground { (object, error) in
                object?.incrementKey("likes", byAmount: self.didLike as NSNumber)
                object?.saveInBackground(block: { (success, error) in
                    if error == nil {
                        // add new like to likes table
                        let object = PFObject(className: "likes")
                        object["by"] = PFUser.current()?.username
                        object["to"] = self.header.usernameBtn.titleLabel!.text!
                        object["uuid"] = self.header.uuidLbl.text!
                        object["count"] = self.didLike
                        object.saveInBackground()
                    } else {
                        print(error!.localizedDescription)
                    }
                })
            }
        }
    }
    
    @objc func back(sender: UIBarButtonItem) {
        
        // push back
        self.navigationController?.popViewController(animated: true)
        
        // clean comment uuid from holding last information
        if !commentuuid.isEmpty {
            commentuuid.removeLast()
        }
        
        // clean comment owner from last holding information
        if !commentowner.isEmpty {
            commentowner.removeLast()
        }
    }
    
    @objc func more(sender: UIBarButtonItem) {
        
        // delete action
        let delete = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: UIAlertActionStyle.default) { (UIAlertAction) in
            
            // delete posts on server
            print("commentVC delete post")
            let postQuery = PFQuery(className: "posts")
            postQuery.whereKey("uuid", equalTo: commentuuid.last!)
            postQuery.findObjectsInBackground(block: { (objects, error) in
                if error == nil {
                    for object in objects! {
                        object.deleteInBackground(block: { (success, error) in
                            if success {
                                // back func, delete uuid
                                self.back(sender: sender)
                            } else {
                                print(error!.localizedDescription)
                            }
                        })
                    }
                } else {
                    print(error!.localizedDescription)
                }
            })
            
            // delete comments on server
            print("commentVC delete comments to the post")
            let commentQuery = PFQuery(className: "comments")
            commentQuery.whereKey("to", equalTo: commentuuid.last!)
            commentQuery.findObjectsInBackground(block: { (objects, error) in
                if error == nil {
                    for object in objects! {
                        object.deleteEventually()
                    }
                } else {
                    print(error!.localizedDescription)
                }
            })
            
            // decrement totalPosts of the theme
            print("commentVC decrement totalPosts of the theme")
            print(self.header.themeuuid.text!)
            let themeQuery = PFQuery(className: "themes")
            themeQuery.whereKey("themeuuid", equalTo: self.header.themeuuid.text!)
            themeQuery.findObjectsInBackground(block: { (objects, error) in
                if error == nil {
                    print("1")
                    for object in objects! {
                        object.incrementKey("totalPosts", byAmount: -1)
                        object.saveEventually()
                    }
                } else {
                    print(error!.localizedDescription)
                }
            })
            
            // delete notifications on server
            print("commentVC delete comment notifications of the post")
            let newsQuery = PFQuery(className: "news")
            newsQuery.whereKey("uuid", equalTo: commentuuid.last!)
            newsQuery.findObjectsInBackground(block: { (objects, error) in
                if error == nil {
                    for object in objects! {
                        object.deleteEventually()
                    }
                } else {
                    print(error!.localizedDescription)
                }
            })
        }
        
        
        // complain action
        let complain = UIAlertAction(title: NSLocalizedString("Complain", comment: ""), style: UIAlertActionStyle.default) { (UIAlertAction) in
            
            // alert if not logged in
            if !isLoggedIn {
                self.alert(title: NSLocalizedString("please sign in", comment: ""), message: NSLocalizedString("sign in from profile page", comment: ""))
                return
            }
            
            // send complain to server
            print("commentVC send complain")
            let complainObj = PFObject(className: "complain")
            complainObj["by"] = PFUser.current()?.username
            complainObj["to"] = commentowner.last!
            complainObj["uuid"] = commentuuid.last!
            complainObj.saveInBackground(block: { (success, error) in
                if success {
                    self.alert(title: "Complain has been made successfully", message: "Thank you! We will consider your complain")
                } else {
                    self.alert(title: "Error", message: error!.localizedDescription)
                }
            })
        }
        
        // share button
        let shareTwitter = UIAlertAction(title: NSLocalizedString("Share on Twitter", comment: ""), style: UIAlertActionStyle.default) { (UIAlertAction) in
            
            // show tweet view
            let composer = TWTRComposer()
            composer.setText("[\(self.header.titleLbl.text!)]  \(self.header.ideaLbl.text!) #YourStupidInventions ")
            composer.setImage(self.header.themeImg.image)
            composer.show(from: self) { (result) in
            }
            
        }
        
        // CANCEL ACTION
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.cancel, handler: nil)
        
        // create menu controller
        let menu = UIAlertController(title: "Menu", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        
        // if post belongs to user, they can delete, else they can only complain
        if commentowner.last! == PFUser.current()?.username {

            // menu.title = NSLocalizedString("Delete menu", comment: "")
            
            menu.addAction(shareTwitter)
            menu.addAction(delete)
            menu.addAction(cancel)
        } else {
            
            // menu.title = NSLocalizedString("Complain menu", comment: "")
            
            menu.addAction(shareTwitter)
            menu.addAction(complain)
            menu.addAction(cancel)
        }
        
        // show menu
        self.present(menu, animated: true, completion: nil)
    }
    
    
    // clicked post idea button
    // go to postIdeaVC for the theme
    @IBAction func postIdeaBtn_clicked(_ sender: Any) {
        
        themeuuid.append(header.themeuuid.text!)
        themetitle.append(header.titleLbl.text!)
        
        // present postIdeaVC
        let postIdea = self.storyboard?.instantiateViewController(withIdentifier: "postIdeaVC") as! postIdeaVC
        self.navigationController?.pushViewController(postIdea, animated: true)
    }
    
    
    // alert func
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

}
