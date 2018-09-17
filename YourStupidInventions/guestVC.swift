//
//  guestVC.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/29/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse

var guestname = [String]()

class guestVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
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
        
        // always vertical scroll
        self.collectionView?.alwaysBounceVertical = true
        
        // background color
        collectionView?.backgroundColor = .white
        
        // top title
        self.navigationItem.title = guestname.last
        
        // new back button
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.back))
        self.navigationItem.leftBarButtonItem = backBtn
        
        // swipe to back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.back))
        backSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(backSwipe)
        
        // pull to refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(self.loadPosts), for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refresher)
        
        // receive notification from editVC
        NotificationCenter.default.addObserver(self, selector: #selector(self.reload), name: NSNotification.Name(rawValue: "reload"), object: nil)
        
        // load posts func
        loadPosts()
    }
    
    
    @objc func back(sender: UIBarButtonItem) {
        
        // push back
        self.navigationController?.popViewController(animated: true)
        
        // pop the last username from guestname array
        if !guestname.isEmpty {
            guestname.removeLast()
        }
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
        query.whereKey("username", equalTo: guestname.last!)
        query.limit = pageLimit
        query.addDescendingOrder("createdAt")
        
        print("guestVC loadPosts")
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
        
        // count total posts of the user to enable or disable refresher
        print("guestVC loadmore count")
        let countQuery = PFQuery(className: "posts")
        countQuery.whereKey("username", equalTo: guestname.last!)
        countQuery.countObjectsInBackground (block: { (count, error) -> Void in
            
            // self refresher
            self.refresher.endRefreshing()
            
            // if posts on server are more than shown
            if self.uuidArray.count < count {
                
                let query = PFQuery(className: "posts")
                query.whereKey("username", equalTo: guestname.last!)
                query.addDescendingOrder("createdAt")
                
                // load only the next page size posts
                query.skip = self.page
                query.limit = self.pageLimit
                
                // increase page size
                self.page = self.page + self.pageLimit
                
                print("guestVC loadmore")
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
                
                // reload collectionView and end refresh animation
                self.collectionView?.reloadData()
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
    
    
    // header config (count likes and posts)
    var postCount: Int32 = 0
    var likeCount: Int32 = 0
    
    func countPostsAndLikes() {
        // count total posts
        print("homeVC count total posts")
        let posts = PFQuery(className: "posts")
        posts.whereKey("username", equalTo: guestname.last!)
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
        likes.whereKey("username", equalTo: guestname.last!)
        likes.findObjectsInBackground { (objects, error) in
            if error == nil {
                for object in objects! {
                    totalLikes = totalLikes + (object.value(forKey: "likes") as? Int32)!
                }
                self.likeCount = totalLikes
                
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    // header config
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // define header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "homeHeaderView", for: indexPath) as! homeHeaderView
        
        // load data of guest
        print("guestVC get guest's data")
        let infoQuery = PFQuery(className: "_User")
        infoQuery.whereKey("username", equalTo: guestname.last!)
        infoQuery.findObjectsInBackground { (objects, error) in
            if error == nil {
                
                // shown wrong user
                if objects!.isEmpty {
                    // call alert
                    self.alert(title: "\(guestname.last!)", message: NSLocalizedString("does not exist", comment: ""))
                    self.navigationController?.popViewController(animated: true)
                }
                
                for object in objects! {
                    
                    // find related to user information
                    header.fullnameLbl.text = (object.value(forKey: "fullname") as? String)?.uppercased()
                    header.usernameLbl.text = guestname.last!
                    let avaFile: PFFile = (object.value(forKey: "ava") as? PFFile)!
                    avaFile.getDataInBackground(block: { (data, error) in
                        if error == nil {
                            header.avaImg.image = UIImage(data: data!)
                        } else {
                            print(error!.localizedDescription)
                        }
                    })
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        
        // place counted post and like count
        header.ideas.text = String(postCount)
        header.likes.text = String(likeCount)
        
        return header
    }
    
    
    // go to the post
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // send uuid to "postuuid" variable
        commentuuid.append(uuidArray[indexPath.row])
        commentowner.append(guestname.last!)
        
        // navigate to postVC
        let comment = self.storyboard?.instantiateViewController(withIdentifier: "commentVC") as! commentVC
        self.navigationController?.pushViewController(comment, animated: true)
    }
    
    // alert func
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
}

