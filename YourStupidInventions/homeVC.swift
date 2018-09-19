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
    // also false if no more to load
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
        
        
        // new back button if not root
        if (self.navigationController?.viewControllers.first != self.navigationController?.visibleViewController) {
            
            // new back button
            self.navigationItem.hidesBackButton = true
            let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.back))
            self.navigationItem.leftBarButtonItem = backBtn
            
            // swipe to back
            let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.back))
            backSwipe.direction = UISwipeGestureRecognizerDirection.right
            self.view.addGestureRecognizer(backSwipe)
        }
        
        // load posts if user has logged in
        if isLoggedIn {
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
    
    
    // load posts func
    @objc func loadPosts() {
        
        // update posts and likes count
        countPostsAndLikes()
        
        // set loading status to processing
        isLoading = true
        
        // clean up
        self.uuidArray.removeAll(keepingCapacity: false)
        self.themeImgArray.removeAll(keepingCapacity: false)
        self.ideaArray.removeAll(keepingCapacity: false)
        self.likesArray.removeAll(keepingCapacity: false)
        
        let query = PFQuery(className: "posts")
        query.whereKey("username", equalTo: PFUser.current()!.username!)
        query.limit = pageLimit
        self.page = self.pageLimit
        query.addDescendingOrder("createdAt")
        print("homeVC loadPost")
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
                
        let query = PFQuery(className: "posts")
        query.whereKey("username", equalTo: PFUser.current()!.username!)
         query.addDescendingOrder("createdAt")
        
        // load only the next page size posts
        query.skip = self.page
        query.limit = self.pageLimit
        
        // increase page size
        self.page = self.page + self.pageLimit
        
        print("homeVC loadmore")
        self.processQuery(query: query)
    }
    
    
    // process query and store data in array
    func processQuery(query: PFQuery<PFObject>) {
        query.findObjectsInBackground { (objects, error) in
            
            // reload collectionView and end refresh animation
            self.collectionView?.reloadData()
            self.refresher.endRefreshing()
            
            if error == nil {
                
                // if no more object is found, and loadmore process
                if objects?.count == 0 {
                    return
                }
                
                // find objects related to our request
                for object in objects! {
                    
                    // check empty
                    if (object.object(forKey: "uuid") != nil &&
                        object.object(forKey: "theme") != nil &&
                        object.object(forKey: "idea") != nil &&
                        object.value(forKey: "likes") != nil
                        ) {
                    
                        // add found data to arrays
                        self.uuidArray.append(object.object(forKey: "uuid") as! String)
                        self.themeImgArray.append(object.object(forKey: "theme") as! PFFile)
                        self.ideaArray.append(object.object(forKey: "idea") as! String)
                        self.likesArray.append(object.value(forKey: "likes") as! Int)
                    }
                }
                
                // set loading status to finished if loaded something
                if !(objects?.isEmpty)! {
                    self.isLoading = false
                }
                
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    
    // clicked setting button
    @IBAction func settingBtn_clicked(_ sender: Any) {
        let settingVC = storyboard?.instantiateViewController(withIdentifier: "settingVC") as! settingVC
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    // preload func
    override func viewWillAppear(_ animated: Bool) {
        
        // go to login if not yet signed in
        if !isLoggedIn {
            let signIn = self.storyboard?.instantiateViewController(withIdentifier: "signInVC") as! signInVC
            self.navigationController?.pushViewController(signIn, animated: true)
        }
    }
    

    // number of cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return uuidArray.count
    }
    
    // cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = self.view.frame.size.width / 2 * 0.5625 + 75
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
        cell.likesLbl.text = "\(likesArray[indexPath.row]) pt"
    
        return cell
    }
    
    
    // header config
    var postCount: Int32 = 0
    var likeCount: Int32 = 0
    
    func countPostsAndLikes() {
        // count total posts
        print("homeVC count total posts")
        let posts = PFQuery(className: "posts")
        posts.whereKey("username", equalTo: PFUser.current()!.username!)
        posts.countObjectsInBackground { (count, error) in
            if error == nil {
                self.postCount = count
            }
        }
        
        // initialize
        var totalLikes: Int32 = 0
        
        // count total likes
        print("homeVC count total likes")
        let likes = PFQuery(className: "posts")
        likes.whereKey("username", equalTo: PFUser.current()!.username!)
        likes.findObjectsInBackground { (objects, error) in
            if error == nil {
                for object in objects! {
                    totalLikes = totalLikes + (object.value(forKey: "likes") as? Int32)!
                }
                self.likeCount = totalLikes
                self.collectionView?.reloadData()
                
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // define header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "homeHeaderView", for: indexPath) as! homeHeaderView
        
        // create header if user has logged in
        if isLoggedIn {
            
            // get user data with connections to columns of PFUser class
            header.fullnameLbl.text = (PFUser.current()?.object(forKey: "fullname") as? String)?.uppercased()
            header.usernameLbl.text = PFUser.current()?.username!
            
            let avaQuery = PFUser.current()?.object(forKey: "ava") as! PFFile
            avaQuery.getDataInBackground { (data, error) in
                header.avaImg.image = UIImage(data: data!)
            }

            // place counted post and like count
            header.ideas.text = String(postCount)
            header.likes.text = String(likeCount)

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
