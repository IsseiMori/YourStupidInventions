//
//  homeVC.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/27/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse


class homeVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // refresher variable
    var refresher = UIRefreshControl()
    
    // page size
    var page: Int = 8
    
    // # of posts to load at each loadMore()
    var pageLimit: Int = 4
    
    // loading status to avoid keep loading
    var isLoading = false
    
    var uuidArray = [String]()
    var themeImgArray = [PFFile]()
    var ideaArray = [String]()
    var likesArray = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewWillAppear(false)

        // always vertical scroll
        self.collectionView?.alwaysBounceVertical = true
        
        // background color
        collectionView?.backgroundColor = .white
        
        // title at the top
        self.navigationItem.title = PFUser.current()?.username?.lowercased()

        // pull to refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(self.loadPosts), for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refresher)
        
        // receive notification from editVC
        NotificationCenter.default.addObserver(self, selector: #selector(self.reload), name: NSNotification.Name(rawValue: "reload"), object: nil)
        
        // new back button if not root
        if (self.navigationController?.viewControllers.first != self.navigationController?.visibleViewController) {
            
            self.navigationItem.hidesBackButton = true
            let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.back))
            self.navigationItem.leftBarButtonItem = backBtn
        }
        
        // load posts if user has logged in
        if UserDefaults.standard.string(forKey: "username") != nil {
            loadPosts()
        }
    }
    
    
    @objc func back(sender: UITabBarItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // refreshing func
    @objc func refresh() {
        
        //reload data information
        collectionView?.reloadData()
        
        // stop refresh animation
        refresher.endRefreshing()
    }
    
    // reload func with profile after receiving notification
    @objc func reload(notification: NSNotification) {
        collectionView?.reloadData()
    }
    
    // load posts func
    @objc func loadPosts() {
        
        // set loading status to processing
        isLoading = true
        
        // clean up
        self.uuidArray.removeAll(keepingCapacity: false)
        self.themeImgArray.removeAll(keepingCapacity: false)
        self.ideaArray.removeAll(keepingCapacity: false)
        self.likesArray.removeAll(keepingCapacity: false)
        
        let query = PFQuery(className: "posts")
        query.whereKey("username", equalTo: PFUser.current()!.username!)
        query.limit = page
        query.addDescendingOrder("createdAt")
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
        countQuery.whereKey("username", equalTo: PFUser.current()!.username!)
        countQuery.countObjectsInBackground (block: { (count, error) -> Void in
            
            // self refresher
            self.refresher.endRefreshing()
            
            // if posts on server are more than shown
            if self.uuidArray.count < count {
                
                let query = PFQuery(className: "posts")
                query.whereKey("username", equalTo: PFUser.current()!.username!)
                 query.addDescendingOrder("createdAt")
                
                // load only the next page size posts
                query.skip = self.page
                query.limit = self.pageLimit
                
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
                
                
                // find objects related to our request
                for object in objects! {
                    
                    // add found data to arrays
                    self.uuidArray.append(object.object(forKey: "uuid") as! String)
                    self.themeImgArray.append(object.object(forKey: "theme") as! PFFile)
                    self.ideaArray.append(object.object(forKey: "idea") as! String)
                    self.likesArray.append(object.value(forKey: "likes") as! Int)
                }
                
                // reload collectionView and end refresh animation
                self.collectionView?.reloadData()
                self.refresher.endRefreshing()
                
                // set loading status to finished
                self.isLoading = false
                
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    
    // preload func
    override func viewWillAppear(_ animated: Bool) {
        print("pre")
        // go to login if not yet signed in
        let username: String? = UserDefaults.standard.string(forKey: "username")
        
        if username == nil {
            let signIn = self.storyboard?.instantiateViewController(withIdentifier: "signInVC") as! signInVC
            print("go")
            self.navigationController?.pushViewController(signIn, animated: true)
        }
    }
    

    // number of cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return uuidArray.count
    }
    
    // cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = self.view.frame.size.width / 2 * 0.5625 + 50 + 15
        let size = CGSize(width: self.view.frame.size.width / 2, height: height)
        return size
    }
    
    // cell config
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! homePostCell
        
    
        themeImgArray[indexPath.row].getDataInBackground { (data, error) in
            if error == nil {
                cell.themeImg.image = UIImage(data: data!)
            } else {
                print(error!.localizedDescription)
            }
        }
        
        cell.ideaLbl.text = ideaArray[indexPath.row]
        cell.likesLbl.text = String(likesArray[indexPath.row])
    
        return cell
    }
    
    
    // header config
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // define header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "homeHeaderView", for: indexPath) as! homeHeaderView
        
        // get user data with connections to columns of PFUser class
        header.fullnameLbl.text = (PFUser.current()?.object(forKey: "fullname") as? String)?.uppercased()
        header.usernameLbl.text = PFUser.current()?.username!
        
        let avaQuery = PFUser.current()?.object(forKey: "ava") as! PFFile
        avaQuery.getDataInBackground { (data, error) in
            header.avaImg.image = UIImage(data: data!)
        }

        // count total posts
        let posts = PFQuery(className: "posts")
        posts.whereKey("username", equalTo: PFUser.current()!.username!)
        posts.countObjectsInBackground { (count, error) in
            if error == nil {
                header.ideas.text = "\(count)"
            }
        }
        
        // count total likes
        let likes = PFQuery(className: "likes")
        likes.whereKey("to", equalTo: PFUser.current()!.username!)
        likes.countObjectsInBackground { (count, error) in
            if error == nil {
                header.likes.text = "\(count)"
            }
        }

        return header
    }
    
    
    // go to the post
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // send uuid to "postuuid" variable
        commentuuid.append(uuidArray[indexPath.row])
        commentowner.append((PFUser.current()?.username)!)
        
        // navigate to postVC
        let comment = self.storyboard?.instantiateViewController(withIdentifier: "commentVC") as! commentVC
        self.navigationController?.pushViewController(comment, animated: true)
    }

    

}
