//
//  themesVC.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/28/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse
import XLPagerTabStrip

class themesVC: UITableViewController, IndicatorInfoProvider {
    
    // UI objects
    var refresher = UIRefreshControl()
    
    
    // arrays to hold data
    var titleArray = [String]()
    var themeuuidArray = [String]()
    var themeImgArray = [PFFile]()
    var totalPostsArray = [Int32]()
    
    // page size
    var page: Int = 5
    
    // page limit at each loarMore
    var pageLimit: Int = 5
    
    // loading status to avoid keep loading
    var isLoading = false
    
    // Title for XLPagerTabStrip
    var itemInfo: IndicatorInfo = "-"
    
    // set up in menuVC
    var sortBy: String = ""
    var filterByAdj: String = ""
    var filterByNoun: String = ""
    var filterByCategory: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Themes"
        
        // tableView margin in the bottom to avoid the last cell to be hidden by tabBar
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        
        //automatic row height - dynamic cell
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        // pull to refresh
        refresher.addTarget(self, action: #selector(self.loadPosts), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        
        // receive notification from postThemeVC
        NotificationCenter.default.addObserver(self, selector: #selector(self.uploaded), name: NSNotification.Name(rawValue: "themeUploaded"), object: nil)
        
        // call load posts func
        loadPosts()
        
    }
    
    
    // reload func with posts after receiving notification
    @objc func uploaded(notification: NSNotification) {
        loadPosts()
    }
    
    
    // load posts
    @objc func loadPosts() {
        
        // set loading status to processing
        isLoading = true
        
        // clean up arrays
        self.titleArray.removeAll(keepingCapacity: false)
        self.themeuuidArray.removeAll(keepingCapacity: false)
        self.themeImgArray.removeAll(keepingCapacity: false)
        self.totalPostsArray.removeAll(keepingCapacity: false)
        
        let query = PFQuery(className: "themes")
        query.limit = pageLimit
        query.addDescendingOrder("createdAt")
        
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
        
        print("themesVC loadPosts")
        processQuery(query: query)

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
                
        let query = PFQuery(className: "themes")
        
        // load only the next page size posts
        query.skip = self.page
        query.limit = self.pageLimit
        query.addDescendingOrder("createdAt")
        
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
        
        // increase page size
        self.page = self.page + self.pageLimit
        
        self.isLoading = false
        
        print("themesVC loadmore")
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
                
                // store objects data into arrays
                for object in objects! {
                    self.titleArray.append(object.object(forKey: "title") as! String)
                    self.themeuuidArray.append(object.object(forKey: "themeuuid") as! String)
                    self.themeImgArray.append(object.object(forKey: "theme") as! PFFile)
                    self.totalPostsArray.append(object.value(forKey: "totalPosts") as! Int32)
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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themeuuidArray.count
    }
    
    
    // cell config
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // define cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! themeCell
        
        cell.titleLbl.text = titleArray[indexPath.row]
        cell.themeuuidLbl.text = themeuuidArray[indexPath.row]
        
        themeImgArray[indexPath.row].getDataInBackground { (data, error) in
            if error == nil {
                cell.themeImg.image = UIImage(data: data!)
            } else {
                print(error!.localizedDescription)
            }
        }
        
        // total posts of the theme
        cell.postsLbl.text = String(totalPostsArray[indexPath.row])
        
        // assign index
        cell.postIdeaBtn.layer.setValue(indexPath, forKey: "index")
        cell.postIdeaBtn.layer.setValue(themeuuidArray[indexPath.row], forKey: "themeuuid")
        cell.postIdeaBtn.layer.setValue(titleArray[indexPath.row], forKey: "title")
        
        return cell
    }
    
    
    // header height
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    
    // header config
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "themesHeaderCell") as! themesHeaderCell
        return header.contentView
    }
    
    
    // clicked a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        themeuuid.append(themeuuidArray[indexPath.row])
        themetitle.append(titleArray[indexPath.row])
        
        // present postIdeaVC
        let postIdea = self.storyboard?.instantiateViewController(withIdentifier: "postIdeaVC") as! postIdeaVC
        self.navigationController?.pushViewController(postIdea, animated: true)
    }

    
    // clicked post idea button
    @IBAction func postIdeaBtn_clicked(_ sender: Any) {
        
        // call the button
        let button = sender as! UIButton
        
        themeuuid.append(button.layer.value(forKey: "themeuuid") as! String)
        themetitle.append(button.layer.value(forKey: "title") as! String)
        
        // present postIdeaVC
        let postIdea = self.storyboard?.instantiateViewController(withIdentifier: "postIdeaVC") as! postIdeaVC
        self.navigationController?.pushViewController(postIdea, animated: true)
        
    }
    
    
    // required for XLPagerTabStrip
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
}
