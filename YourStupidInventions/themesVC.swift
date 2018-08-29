//
//  themesVC.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/28/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse

class themesVC: UITableViewController {
    
    // UI objects
    var refresher = UIRefreshControl()
    
    
    // arrays to hold data
    var themeuuidArray = [String]()
    var themeImgArray = [PFFile]()
    var hashtagsArray = [String]()
    
    // page size
    var page: Int = 5
    
    // page limit at each loarMore
    var pageLimit: Int = 5
    
    // loading status to avoid keep loading
    var isLoading = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Themes"
        
        //automatic row height - dynamic cell
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        // pull to refresh
        refresher.addTarget(self, action: #selector(self.loadPosts), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        
        // call load posts func
        loadPosts()
        
    }
    
    
    
    // load posts
    @objc func loadPosts() {
        
        // set loading status to processing
        isLoading = true
        
        // clean up arrays
        self.themeuuidArray.removeAll(keepingCapacity: false)
        self.themeImgArray.removeAll(keepingCapacity: false)
        self.hashtagsArray.removeAll(keepingCapacity: false)
        
        let query = PFQuery(className: "themes")
        query.limit = page
        query.addAscendingOrder("createdAt")
        processQuery(query: query)

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
            if self.themeuuidArray.count < count {
                
                let query = PFQuery(className: "themes")
                
                // load only the next page size posts
                query.skip = self.page
                query.limit = self.pageLimit
                query.addDescendingOrder("createdAt")
                
                // increase page size
                self.page = self.page + self.pageLimit
                
                self.processQuery(query: query)
                
            }
        })
    }

    // process query and store data in array
    func processQuery(query: PFQuery<PFObject>) {
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                
                // store objects data into arrays
                for object in objects! {
                    self.themeuuidArray.append(object.object(forKey: "themeuuid") as! String)
                    self.themeImgArray.append(object.object(forKey: "theme") as! PFFile)
                    self.hashtagsArray.append(object.object(forKey: "hashtags") as! String)
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
        return themeuuidArray.count
    }
    
    
    // cell config
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // define cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! themeCell
        
        cell.themeuuidLbl.text = themeuuidArray[indexPath.row]
        cell.hashtagsLbl.text = hashtagsArray[indexPath.row]
        
        themeImgArray[indexPath.row].getDataInBackground { (data, error) in
            if error == nil {
                cell.themeImg.image = UIImage(data: data!)
            } else {
                print(error!.localizedDescription)
            }
        }
        
        // count number of posts
        let postsQuery = PFQuery(className: "posts")
        postsQuery.whereKey("themeuuid", equalTo: self.themeuuidArray[indexPath.row])
        postsQuery.countObjectsInBackground(block: { (count, error) in
            if error == nil {
                cell.postsLbl.text = "\(count)"
            } else {
                print(error!.localizedDescription)
            }
        })
        
        
        // assign index
        cell.postsBtn.layer.setValue(indexPath, forKey: "index")
        
        
        return cell
    }
    
    
    // clicked a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        themeuuid.append(themeuuidArray[indexPath.row])
        
        // present postIdeaVC
        let postIdea = self.storyboard?.instantiateViewController(withIdentifier: "postIdeaVC") as! postIdeaVC
        self.navigationController?.pushViewController(postIdea, animated: true)
    }


}
