//
//  newVC.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/26/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse

class newVC: UITableViewController {

    // UI objects
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var refresher = UIRefreshControl()
    
    // arrays to hold data from server
    var uuidArray = [String]()
    var themeArray = [PFFile]()
    var ideaArray = [String]()
    var hashtagsArray = [String]()
    var usernameArray = [String]()
    var fullnameArray = [String]()
    var dateArray = [Date?]()
    var likesArray = [Int]()
    
    
    // page size
    var page: Int = 10
    
    // default
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title at the top
        self.navigationItem.title = "New Ideas"
        
        // automatic row height - dynamic cell
        //tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        // centering indicator
        indicator.center.x = tableView.center.x
        
        // call load posts func
        loadPosts()
        
    }
    
    
    // load posts
    func loadPosts() {
        
        let query = PFQuery(className: "posts")
        query.limit = page
        query.addAscendingOrder("createAt")
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                
                // clean up
                self.uuidArray.removeAll(keepingCapacity: false)
                self.themeArray.removeAll(keepingCapacity: false)
                self.ideaArray.removeAll(keepingCapacity: false)
                self.hashtagsArray.removeAll(keepingCapacity: false)
                self.usernameArray.removeAll(keepingCapacity: false)
                self.fullnameArray.removeAll(keepingCapacity: false)
                self.dateArray.removeAll(keepingCapacity: false)
                self.likesArray.removeAll(keepingCapacity: false)
                
                // find related objects
                for object in objects! {
                    self.uuidArray.append(object.object(forKey: "uuid") as! String)
                    self.themeArray.append(object.object(forKey: "theme") as! PFFile)
                    self.ideaArray.append(object.object(forKey: "idea") as! String)
                    self.hashtagsArray.append(object.object(forKey: "hashtags") as! String)
                    self.usernameArray.append(object.object(forKey: "username") as! String)
                    self.fullnameArray.append(object.object(forKey: "fullname") as! String)
                    self.dateArray.append(object.createdAt!)
                    self.likesArray.append(object.value(forKey: "likes") as! Int)
                }
                
                // reload tableView and end refresh animation
                self.tableView.reloadData()
                self.refresher.endRefreshing()
                
                
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    
    // number of cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.uuidArray.count
    }
    
    
    // cell config
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // define cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! postCell
        
        // cell color
        cell.backgroundColor = UIColor.clear
        
        // connect objects with data from arrays
        cell.ideaLbl.text = self.ideaArray[indexPath.row]
        cell.hashtagsLbl.text = self.hashtagsArray[indexPath.row]
        cell.likeLbl.text = String(self.likesArray[indexPath.row])
        cell.usernameBtn.setTitle(self.usernameArray[indexPath.row], for: UIControlState.normal)
        cell.uuidLbl.text = self.uuidArray[indexPath.row]
        
        // place theme image
        self.themeArray[indexPath.row].getDataInBackground { (data, error) in
            if error == nil {
                cell.themeImg.image = UIImage(data: data!)
            } else {
                print(error!.localizedDescription)
            }
        }
        
        // calculate post date
        let from = dateArray[indexPath.row]
        let now = Date()
        let components : NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
        let difference = (Calendar.current as NSCalendar).components(components, from: from!, to: now, options: [])
        
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
        
        
        // assign index
        cell.usernameBtn.layer.setValue(indexPath, forKey: "index")
        
        
        
        return cell
    }
    
    
    // selected a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // call cell for further cell data
        let cell = tableView.cellForRow(at: indexPath) as! postCell
        
        commentuuid.append(cell.uuidLbl.text!)
        commentowner.append(cell.usernameBtn.titleLabel!.text!)
        
        // present commentVC
        let comment = self.storyboard?.instantiateViewController(withIdentifier: "commentVC") as! commentVC
        self.navigationController?.pushViewController(comment, animated: true)
        
    }

}
