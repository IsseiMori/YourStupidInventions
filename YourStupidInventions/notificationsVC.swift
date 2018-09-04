//
//  notificationsVC.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/29/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse

class notificationsVC: UITableViewController {
    
    // arrays to hold data from server
    var usernameArray = [String]()
    var typeArray = [String]()
    var dateArray = [Date?]()
    var uuidArray = [String]()
    var ownerArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView margin in the bottom to avoid the last cell to be hidden by tabBar
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0)

        // dynamic cell height
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        // title on the top
        navigationItem.title = "Notifications"
        
        // load posts if user has logged in
        if isLoggedIn {
            
            // request query
            let query = PFQuery(className: "news")
            query.whereKey("to", equalTo: PFUser.current()!.username!)
            query.limit = 30
            query.findObjectsInBackground { (objects, error) in
                if error == nil {
                    
                    // clean up
                    self.usernameArray.removeAll(keepingCapacity: false)
                    self.typeArray.removeAll(keepingCapacity: false)
                    self.dateArray.removeAll(keepingCapacity: false)
                    self.uuidArray.removeAll(keepingCapacity: false)
                    self.ownerArray.removeAll(keepingCapacity: false)
                    
                    // find related objects
                    for object in objects! {
                        self.usernameArray.append(object.object(forKey: "by") as! String)
                        self.typeArray.append(object.object(forKey: "type") as! String)
                        self.dateArray.append(object.createdAt)
                        self.uuidArray.append(object.object(forKey: "uuid") as! String)
                        self.ownerArray.append(object.object(forKey: "owner") as! String)
                        
                        // save notifications as checked
                        object["checked"] = "yes"
                        object.saveEventually()
                    }
                    
                    // reload tableView
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernameArray.count
    }

    // cell config
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // declare cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! notificationsCell
        
        cell.usernameBtn.setTitle(usernameArray[indexPath.row], for: UIControlState.normal)
        
        // calculate post date
        let from = dateArray[indexPath.row]
        let now = Date()
        let components : NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
        let difference = (Calendar.current as NSCalendar).components(components, from: from! as Date, to: now, options: [])
        
        // logic what to show: seconds, minutes, hours, days, or weeks
        if difference.second! <= 0 {
            cell.dateLbl.text = "now"
        }
        if difference.second! > 0 && difference.minute! == 0 {
            cell.dateLbl.text = "\(String(describing: difference.second!))s. ago"
        }
        if difference.minute! > 0 && difference.hour! == 0 {
            cell.dateLbl.text = "\(String(describing: difference.minute!))m. ago"
        }
        if difference.hour! > 0 && difference.day! == 0 {
            cell.dateLbl.text = "\(String(describing: difference.hour!))h. ago"
        }
        if difference.day! > 0 && difference.weekOfMonth! == 0 {
            cell.dateLbl.text = "\(String(describing: difference.day!))d. ago"
        }
        if difference.weekOfMonth! > 0 {
            cell.dateLbl.text = "\(String(describing: difference.weekOfMonth!))w."
        }
        
        // define info
        if typeArray[indexPath.row] == "comment" {
            cell.infoLbl.text = "has commented on your post."
        }
        if typeArray[indexPath.row] == "like" {
            cell.infoLbl.text = "liked your post."
        }
        
        // assign index of button
        cell.usernameBtn.layer.setValue(indexPath, forKey: "index")
        
        return cell
    }
    
    
    // clicked cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // call cell for further cell data
        let cell = tableView.cellForRow(at: indexPath) as! notificationsCell
        
        // going to own comments
        if cell.infoLbl.text == "has commented on your post." {
            
            // send related data to global variables
            commentuuid.append(uuidArray[indexPath.row])
            commentowner.append(ownerArray[indexPath.row])
            
            // go to commentVC
            let comment = self.storyboard?.instantiateViewController(withIdentifier: "commentVC") as! commentVC
            self.navigationController?.pushViewController(comment, animated: true)
        }
        // going to liked post
        if cell.infoLbl.text == "liked your post." {
            
            // send related data to global variables
            commentuuid.append(uuidArray[indexPath.row])
            commentowner.append(ownerArray[indexPath.row])
            
            // go to commentVC
            let comment = self.storyboard?.instantiateViewController(withIdentifier: "commentVC") as! commentVC
            self.navigationController?.pushViewController(comment, animated: true)
        }
    }

    
    // clicked username button
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
}
