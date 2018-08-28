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
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var refresher = UIRefreshControl()
    
    
    // arrays to hold data
    var themeuuidArray = [String]()
    var themeImgArray = [PFFile]()
    var hashtagsArray = [String]()
    
    // page size
    var page: Int = 10

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Themes"
        
        //automatic row height - dynamic cell
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        // centering indicator
        indicator.center.x = tableView.center.x
        
        // call load posts func
        loadPosts()
        
    }
    
    // load posts
    @objc func loadPosts() {
        
        let query = PFQuery(className: "themes")
        query.limit = page
        query.addAscendingOrder("createdAt")
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                
                // clean up arrays
                self.themeuuidArray.removeAll(keepingCapacity: false)
                self.themeImgArray.removeAll(keepingCapacity: false)
                self.hashtagsArray.removeAll(keepingCapacity: false)
                
                // store objects data into arrays
                for object in objects! {
                    self.themeuuidArray.append(object.object(forKey: "themeuuid") as! String)
                    self.themeImgArray.append(object.object(forKey: "theme") as! PFFile)
                    self.hashtagsArray.append(object.object(forKey: "hashtags") as! String)
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


}
