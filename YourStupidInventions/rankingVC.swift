//
//  postVC.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/26/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse

// ranking and new feeds share this class

class rankingVC: UITableViewController {
    
    // UI objects
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
    var page: Int = 5
    
    // # of posts to load at each loadMore()
    var pageLimit: Int = 5
    
    
    // loading status to avoid keep loading
    var isLoading = false
    
    // default
    override func viewDidLoad() {
        super.viewDidLoad()

        // title at the top
        if tabBarController?.selectedIndex == 0 {
            self.navigationItem.title = "Top Ideas"
        } else {
            self.navigationItem.title = "New Ideas"
        }
        
        // automatic row height - dynamic cell
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // need this for pagination?
        tableView.estimatedRowHeight = 300
        
        // pull to refresh
        refresher.addTarget(self, action: #selector(self.loadPosts), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        
        
        // receive post cell liked notification to update tableView
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name.init("liked"), object: nil)
        
        
        // call load posts func
        loadPosts()
        
    }
    
    
    // refreshing func after like to update tableView
    @objc func refresh() {
        self.tableView.reloadData()
        
        // stop refresh animation
        refresher.endRefreshing()
    }

    
    // load posts
    @objc func loadPosts() {
        
        // set loading status to processing
        isLoading = true
        
        // clean up
        self.uuidArray.removeAll(keepingCapacity: false)
        self.themeArray.removeAll(keepingCapacity: false)
        self.ideaArray.removeAll(keepingCapacity: false)
        self.hashtagsArray.removeAll(keepingCapacity: false)
        self.usernameArray.removeAll(keepingCapacity: false)
        self.fullnameArray.removeAll(keepingCapacity: false)
        self.dateArray.removeAll(keepingCapacity: false)
        self.likesArray.removeAll(keepingCapacity: false)
    
        let query = PFQuery(className: "posts")
        query.limit = self.page
        
        // if tab is ranking(0) sort by likes
        // if tab is new(1) sort by time
        if self.tabBarController?.selectedIndex == 0 {
            query.addDescendingOrder("likes")
        } else {
            query.addDescendingOrder("createdAt")
        }
        
        self.processQuery(query: query)
    }
    
    
    // scrolled down
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - self.view.frame.size.height
        let distanceToBottom = maximumOffset - currentOffsetY
        
        if distanceToBottom < 50 {
            // don't load more if still loading
            if !isLoading {
                loadMore()
            }
        }
    }
    
    
    // pagination
    @objc func loadMore() {
        
        // set loading status to processing
        isLoading = true
        
        // count total comments to enable or disable refresher
        let countQuery = PFQuery(className: "posts")
        countQuery.countObjectsInBackground (block: { (count, error) -> Void in
            
            // self refresher
            self.refresher.endRefreshing()
            
            // if posts on server are more than shown
            if self.uuidArray.count < count {
                
                let query = PFQuery(className: "posts")
                
                // load only the next page size posts
                query.skip = self.page
                query.limit = self.pageLimit
                
                // increase page size
                self.page = self.page + self.pageLimit
                
                // if tab is ranking(0) sort by likes
                // if tab is new(1) sort by time
                if self.tabBarController?.selectedIndex == 0 {
                    query.addDescendingOrder("likes")
                } else {
                    query.addDescendingOrder("createdAt")
                }
                
                self.processQuery(query: query)
                
            }
        })
    }
    
    
    // process query and
    func processQuery(query: PFQuery<PFObject>) {
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                
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
                
                // set loading status to finished
                self.isLoading = false
                
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
        
        // change like button color depending on whether user liked or not
        let didLike = PFQuery(className: "likes")
        didLike.whereKey("by", equalTo: PFUser.current()!.username!)
        didLike.whereKey("uuid", equalTo: cell.uuidLbl.text!)
        didLike.countObjectsInBackground { (count, error) in
            // if no likes are found, else found likes
            if count == 0 {
                cell.likeBtn.setTitle("unlike", for: UIControlState.normal)
                cell.likeBtn.setBackgroundImage(UIImage(named: "unlike.png"), for: UIControlState.normal)
            } else {
                cell.likeBtn.setTitle("like", for: UIControlState.normal)
                cell.likeBtn.setBackgroundImage(UIImage(named: "like.png"), for: UIControlState.normal)
            }
        }
        
        
        // assign index
        cell.usernameBtn.layer.setValue(indexPath, forKey: "index")
        cell.likeLbl.layer.setValue(cell.likeLbl.text!, forKey: "likes")
        
        
        
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
