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
    
    @IBOutlet weak var tableView: UITableView!
    
    // arrays to hold data from server
    var commentArray = [String]()
    var usernameArray = [String]()
    var dateArray = [Date?]()
    
    // page size
    var page: Int = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // present commentHeaderCell as header
        let headerCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "commentHeaderCell") as! commentHeaderCell
        let headerView: UIView = headerCell.contentView
        tableView.tableHeaderView = headerView
        
        
        // call alignment func
        alignment()
        
        // load comments
        loadComments()
    }
    
    
    // alignment func
    func alignment() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // start tableView from the top
        tableView.frame.origin.y = 0
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
