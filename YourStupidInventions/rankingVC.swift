//
//  postVC.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/26/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse
import XLPagerTabStrip

// ranking and new feeds share this class

class rankingVC: UITableViewController, IndicatorInfoProvider {
    
    // UI objects
    var refresher = UIRefreshControl()
    
    // arrays to hold data from server
    var titleArray = [String]()
    var uuidArray = [String]()
    var themeArray = [PFFile]()
    var ideaArray = [String]()
    var usernameArray = [String]()
    var fullnameArray = [String]()
    var dateArray = [Date?]()
    var likesArray = [Int]()
    var addLikeArray = [Int]()
    
    // page size
    var page: Int = 5
    
    // # of posts to load at each loadMore()
    var pageLimit: Int = 5
    
    
    // loading status to avoid keep loading
    var isLoading = false
    
    // Title for XLPagerTabStrip
    var itemInfo: String = "-"
    
    // set up in menuVC
    var sortBy: String = ""
    var filterByAdj: String = ""
    var filterByNoun: String = ""
    var filterByCategory: String = ""
    
    var ActivityIndicator: UIActivityIndicatorView!
    
    // default
    override func viewDidLoad() {

        super.viewDidLoad()
        
        // tableView margin in the bottom to avoid the last cell to be hidden by tabBar
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0)
        
        // automatic row height - dynamic cell
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // need this for pagination?
        tableView.estimatedRowHeight = 300
        
        // pull to refresh
        refresher.addTarget(self, action: #selector(self.loadPosts), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        
        // Activity Indicator
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        ActivityIndicator.center = self.view.center
        ActivityIndicator.hidesWhenStopped = true
        ActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(ActivityIndicator)
        
        // receive post cell liked notification to update tableView
        // NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name.init("liked"), object: nil)
        
        // call load posts func
        loadPosts()
        
    }
    
    
    // refreshing func after like to update tableView
    @objc func refresh() {
        self.tableView.reloadData()
    }

    
    // load posts
    @objc func loadPosts() {
        
        // start indicator animation
        ActivityIndicator.startAnimating()
        
        // set loading status to processing
        isLoading = true
        
        // clean up
        self.titleArray.removeAll(keepingCapacity: false)
        self.uuidArray.removeAll(keepingCapacity: false)
        self.themeArray.removeAll(keepingCapacity: false)
        self.ideaArray.removeAll(keepingCapacity: false)
        self.usernameArray.removeAll(keepingCapacity: false)
        self.fullnameArray.removeAll(keepingCapacity: false)
        self.dateArray.removeAll(keepingCapacity: false)
        self.likesArray.removeAll(keepingCapacity: false)
        self.addLikeArray.removeAll(keepingCapacity: false)
    
        let query = PFQuery(className: "posts")
        query.limit = self.pageLimit
        
        // sort by likes or time
        if !self.sortBy.isEmpty {
            query.addDescendingOrder(self.sortBy)
        }
        
        // filter
        if !self.filterByAdj.isEmpty {
            query.whereKey("adjective", equalTo: self.filterByAdj)
        }
        if !self.filterByNoun.isEmpty {
            query.whereKey("noun", equalTo: self.filterByNoun)
        }
        if !self.filterByCategory.isEmpty {
            query.whereKey("category", equalTo: self.filterByCategory)
        }
        
        if !selectedLanguages.isEmpty {
            query.whereKey("language", containedIn: selectedLanguages)
        }
        
        
        print("ranking loadPosts")
        self.processQuery(query: query)
    }
    
    
    // scrolled down
    // isAtBottom to avoid keep requesting query
    // has to get out the loadMore area once to request another
    var isAtBottom: Bool = false
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
                
        let query = PFQuery(className: "posts")
        
        // load only the next page size posts
        query.skip = self.page
        query.limit = self.pageLimit
        
        
        // increase page size
        self.page = self.page + self.pageLimit
        
        // sort by likes or time
        if !self.sortBy.isEmpty {
            query.addDescendingOrder(self.sortBy)
        }
        
        // filter
        if !self.filterByAdj.isEmpty {
            query.whereKey("adjective", equalTo: self.filterByAdj)
        }
        if !self.filterByNoun.isEmpty {
            query.whereKey("noun", equalTo: self.filterByNoun)
        }
        if !self.filterByCategory.isEmpty {
            query.whereKey("category", equalTo: self.filterByCategory)
        }
        
        if !selectedLanguages.isEmpty {
            query.whereKey("language", containedIn: selectedLanguages)
        }
        
        print("ranking loadmore")
        self.processQuery(query: query)
                

    }
    
    
    // process query and
    func processQuery(query: PFQuery<PFObject>) {

        query.findObjectsInBackground { (objects, error) in
            
            // end refresh animation
            self.refresher.endRefreshing()
            
            // stop indicator animation
            self.ActivityIndicator.stopAnimating()
            
            if error == nil {
                
                // if no more object is found, end loadmore process
                if objects?.count == 0 {
                    return
                }
                
                // find related objects
                for object in objects! {
                    self.titleArray.append(object.object(forKey: "title") as! String)
                    self.uuidArray.append(object.object(forKey: "uuid") as! String)
                    self.themeArray.append(object.object(forKey: "theme") as! PFFile)
                    self.ideaArray.append(object.object(forKey: "idea") as! String)
                    self.usernameArray.append(object.object(forKey: "username") as! String)
                    self.fullnameArray.append(object.object(forKey: "fullname") as! String)
                    self.dateArray.append(object.createdAt!)
                    self.likesArray.append(object.value(forKey: "likes") as! Int)
                    self.addLikeArray.append(0)
                    
                }
                
                // reload tableView
                self.tableView.reloadData()
                
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
        cell.titleLbl.text = self.titleArray[indexPath.row]
        cell.ideaLbl.text = self.ideaArray[indexPath.row]
        cell.likeLbl.text = String(self.likesArray[indexPath.row] + self.addLikeArray[indexPath.row])
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
        
        // set likeBtn to unlike
        if cell.likeBtn.titleLabel?.text != "like" {
            cell.likeBtn.setTitle("unlike", for: UIControlState.normal)
            cell.likeBtn.setBackgroundImage(UIImage(named: "money_unlike.png"), for: UIControlState.normal)
        }
        
        // assign index
        cell.usernameBtn.layer.setValue(indexPath, forKey: "index")
        cell.likeBtn.layer.setValue(indexPath, forKey: "index")
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
    
    
    // like button clicked
    @IBAction func likeBtn_clicked(_ sender: Any) {
        
        if isLoggedIn {
            
            // get index of the button
            let button = sender as! UIButton
            let index = button.layer.value(forKey: "index") as! IndexPath
            
            // increment addLikeArray
            self.addLikeArray[index.row] = self.addLikeArray[index.row] + 1
            
        } else {
            alert(title: "Please sign in", message: "Sign in from Home page to like this idea.")
        }

    }
    
    
    // preload func
    override func viewWillAppear(_ animated: Bool) {

        // reset addLikeArray to 0
        addLikeArray = Array(repeatElement(0, count: uuidArray.count))
    }
    
    
    // postload func
    override func viewWillDisappear(_ animated: Bool) {
        
        if isLoggedIn {
            
            // save number of likeBtn taps to server
            for index in 0 ..< addLikeArray.count {
                if addLikeArray[index] != 0 {
                    
                    // update total likes in each post
                    let query = PFQuery(className: "posts")
                    query.whereKey("uuid", equalTo: uuidArray[index])
                    print("ranking send like count")
                    query.getFirstObjectInBackground { (object, error) in
                        object?.incrementKey("likes", byAmount: self.addLikeArray[index] as NSNumber)
                        object?.saveInBackground(block: { (success, error) in
                            if error == nil {
                                // add new like to likes table
                                let object = PFObject(className: "likes")
                                object["by"] = PFUser.current()?.username
                                object["to"] = self.usernameArray[index]
                                object["uuid"] = self.uuidArray[index]
                                object["count"] = self.addLikeArray[index]
                                object.saveInBackground()
                            } else {
                                print(error!.localizedDescription)
                            }
                        })
                    }
                }
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
    
    // required for XLPagerTabStrip
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: itemInfo)
    }
    
}
