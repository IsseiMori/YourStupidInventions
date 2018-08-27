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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch")
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
    
    

}
