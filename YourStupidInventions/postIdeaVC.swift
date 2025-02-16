//
//  postIdeaVC.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/28/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse

var themeuuid = [String]()
var themetitle = [String]()

class postIdeaVC: UITableViewController {
    
    // UI objects
    var refresher = UIRefreshControl()

    var header: postIdeaHeader!
    
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
    var page: Int = 10
    
    // # of posts to load at each loadMore()
    var pageLimit: Int = 5
    
    // loading status to avoid keep loading
    var isLoading = false
    
    // send status to avoid sending twice
    var didSend = false
    
    // Done button on keyboard
    var kbToolBar: UIToolbar!
    
    var ActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title at the top
        self.navigationItem.title = themetitle.last!
        
        // automatic row height - dynamic cell
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // declare hide keyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        hideTap.cancelsTouchesInView = false
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // receive notification from postIdeaHeader
        NotificationCenter.default.addObserver(self, selector: #selector(self.uploaded), name: NSNotification.Name(rawValue: "postUploaded"), object: nil)
        
        // new back button
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.back))
        self.navigationItem.leftBarButtonItem = backBtn
        
        // swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.back))
        backSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(backSwipe)
        
        // Activity Indicator
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        ActivityIndicator.center = self.view.center
        ActivityIndicator.hidesWhenStopped = true
        ActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(ActivityIndicator)
        
        // initialize header
        iniHeaderConfig()
        
        // done button on keyboard
        kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default
        kbToolBar.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneButtonTapped))
        kbToolBar.items = [spacer, doneButton]
        header.ideaTxt.inputAccessoryView = kbToolBar
        
        // call load posts func
        loadPosts()

        
    }
    
    
    // enable scroll even there is no post
    override func viewDidAppear(_ animated: Bool) {
        if tableView.contentSize.height < self.view.frame.size.height {
            tableView.contentSize.height = self.view.frame.size.height * 1.5
        }
    }
    
    // tapped done button on keyboard
    @objc func doneButtonTapped() {
        self.view.endEditing(true)
    }
    
    // receive uploaded notification from postIdeaHeader and show newVC
    @objc func uploaded(notification: NSNotification) {
        
        // go to newVC
        self.tabBarController?.selectedIndex = 1
        
        // ba back to themeVC, only this order works
        self.navigationController?.popViewController(animated: false)
    }
    
    
    // hide keyboard if tapped
    @objc func hideKeyboardTap(recognizer: UITapGestureRecognizer) {
        self.header.ideaTxt.resignFirstResponder()
    }
    
    
    // initial header config func
    // call this only in viewDidLoad once
    func iniHeaderConfig() {
        header = tableView.dequeueReusableCell(withIdentifier: "postIdeaHeader") as! postIdeaHeader
        
        // automatic header cell height
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedSectionHeaderHeight = 400;
        
        header.delegate = self
        
        print("postIdeaVC header config")
        let query = PFQuery(className: "themes")
        query.whereKey("themeuuid", equalTo: themeuuid.last!)
        query.getFirstObjectInBackground { (object, error) in
            if error == nil {
                
                self.header.titleLbl.text = "\(NSLocalizedString("what is", comment: "")) \(object?.object(forKey: "title") as! String)"
                self.header.adjLbl.text = object?.object(forKey: "adjective") as? String
                self.header.nounLbl.text = object?.object(forKey: "noun") as? String
                self.header.categoryLbl.text = object?.object(forKey: "category") as? String
                self.header.hashtagsLbl.text = object?.object(forKey: "hashtags") as? String
                self.header.lang = object?.object(forKey: "language") as? String
                self.header.title = object?.object(forKey: "title") as! String
                
                self.header.themeuuidLbl.text = themeuuid.last!
                
                // allow title up to 3 lines
                self.header.titleLbl.numberOfLines = 3
                self.header.titleLbl.sizeToFit()
                
                self.header.themeImgPFFile = object?.object(forKey: "theme") as! PFFile
                (object?.object(forKey: "theme") as? PFFile)?.getDataInBackground(block: { (data, error) in
                    if error == nil {
                        self.header.themeImg.image = UIImage(data: data!)
                    } else {
                        print(error!.localizedDescription)
                    }
                })
                
                // reload to apply auto height and sizeToFit
                self.tableView.reloadData()
            } else {
                self.alertBack(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("this theme doesn't exist", comment: ""))
            }
        }
    }
    
    // header cell config
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header.contentView
    }
    
    // load posts
    func loadPosts() {
        
        // start indicator animation
        ActivityIndicator.startAnimating()
        
        // set loading status to processing
        isLoading = true
        
        let query = PFQuery(className: "posts")
        query.limit = pageLimit
        self.page = self.pageLimit
        query.whereKey("themeuuid", equalTo: themeuuid.last!)
        query.addDescendingOrder("likes")
        
        print("postIdeaVC loadPosts")
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
        
        // load only the next page size posts
        query.skip = self.page
        query.whereKey("themeuuid", equalTo: themeuuid.last!)
        query.addDescendingOrder("likes")
        query.limit = self.pageLimit
        
        // increase page size
        self.page = self.page + self.pageLimit
        
        print("postIdeaVC loadmore")
        self.processQuery(query: query)
        
    }
    
    // process query and
    func processQuery(query: PFQuery<PFObject>) {
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                
                // if no more object is found, end loadmore process
                if objects?.count == 0 {
                    return
                }
                
                // if loadPosts, clean up arrays
                if self.page == self.pageLimit {
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
                }
                
                // find related objects
                for object in objects! {
                    
                    // check empty
                    if (object.object(forKey: "title") != nil &&
                        object.object(forKey: "uuid") != nil &&
                        object.object(forKey: "theme") != nil &&
                        object.object(forKey: "idea") != nil &&
                        object.object(forKey: "username") != nil &&
                        object.object(forKey: "fullname") != nil &&
                        object.value(forKey: "likes") != nil
                        ) {
                    
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
                }
                
                // reload tableView and end refresh animation
                self.tableView.reloadData()
                self.refresher.endRefreshing()
                
                self.ActivityIndicator.stopAnimating()
                
                // set loading status to finished if loaded something
                if !(objects?.isEmpty)! {
                    self.isLoading = false
                }
                
            } else {
                print(error!.localizedDescription)
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uuidArray.count
    }
    
    
    // cell config
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // define cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! postCell
        
        // cell color
        cell.backgroundColor = UIColor.clear
        
        // connect objects with data from arrays
        cell.titleLbl.text = "\(NSLocalizedString("what is", comment: "")) \(self.titleArray[indexPath.row])"
        cell.ideaLbl.text = self.ideaArray[indexPath.row]
        cell.likeLbl.text = String(self.likesArray[indexPath.row])
        cell.usernameBtn.setTitle(self.usernameArray[indexPath.row], for: UIControlState.normal)
        cell.uuidLbl.text = self.uuidArray[indexPath.row]
        
        // allow title up to 3 lines
        cell.titleLbl.numberOfLines = 3
        cell.titleLbl.sizeToFit()
        cell.ideaLbl.numberOfLines = 3
        cell.ideaLbl.sizeToFit()
        
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
    
   
    // clicked like button
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
    
    // selected a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
        // call cell for further cell data
        let cell = tableView.cellForRow(at: indexPath) as! postCell
        
        commentuuid.append(cell.uuidLbl.text!)
        commentowner.append(cell.usernameBtn.titleLabel!.text!)
        
        // present commentVC
        let comment = self.storyboard?.instantiateViewController(withIdentifier: "commentVC") as! commentVC
        self.navigationController?.pushViewController(comment, animated: true)
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
                    print("postIdeaVC send like count")
                    
                    // update total likes in each post
                    let query = PFQuery(className: "posts")
                    query.whereKey("uuid", equalTo: uuidArray[index])
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
    
    @IBAction func sendBtn_clicked(_ sender: Any) {
        
        self.view.endEditing(true)
        
        // start indicator animation
        ActivityIndicator.startAnimating()

        // if status is already sent, return
        if didSend {
            return
        }
        
        // if idea is not entered
        if header.ideaTxt.text!.isEmpty {
            alert(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("enter your idea", comment: ""))
            return
        }
        
        // change send status to yes
        didSend = true
        
        let object = PFObject(className: "posts")
        
        // generate uuid for the new post
        let uuid = UUID().uuidString
        object["uuid"] = "\(PFUser.current()!.username!) \(uuid)"
        
        object["theme"] = header.themeImgPFFile
        object["idea"] = header.ideaTxt.text
        object["username"] = PFUser.current()?.username
        object["fullname"] = PFUser.current()?.object(forKey: "fullname")
        object["likes"] = 0
        object["title"] = header.title
        object["adjective"] = header.adjLbl.text!
        object["noun"] = header.nounLbl.text!
        object["category"] = header.categoryLbl.text!
        object["hashtags"] = header.hashtagsLbl.text!
        object["language"] = header.lang
        
        // copy the themeuuid
        object["themeuuid"] = header.themeuuidLbl.text
        
        print("postIdea save")
        object.saveInBackground { (success, error) in
            if success {
                // send notification with name "uploaded" to postIdeaVC to show newVC
                NotificationCenter.default.post(name: NSNotification.Name.init("postUploaded"), object: nil)
                
                //increment theme totalPosts
                print("postIdeaVC increment totalPosts")
                let countQuery = PFQuery(className: "themes")
                countQuery.whereKey("themeuuid", equalTo: self.header.themeuuidLbl.text!)
                countQuery.getFirstObjectInBackground(block: { (object, error) in
                    if error == nil {
                        object?.incrementKey("totalPosts", byAmount: 1)
                        object?.saveEventually()
                    } else {
                        print(error!.localizedDescription)
                    }
                })
                
                // reset text field
                self.header.ideaTxt.text = ""
                
            } else {
                print(error!.localizedDescription)
                
                // enable next sending
                self.didSend = false
                self.alert(title: "Connection failed", message: "Plese try sending again.")
            }
            
            // stop indicator animation
            self.ActivityIndicator.stopAnimating()
        }
    }
    
    @objc func back(sender: UIBarButtonItem) {
        
        // push back
        self.navigationController?.popViewController(animated: true)
        
        // clean themeuuid from holding last information
        if !themeuuid.isEmpty {
            themeuuid.removeLast()
        }
        
        // clean themetitle from holding last information
        if !themetitle.isEmpty {
            themetitle.removeLast()
        }
    }
    
    // alert func
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    // alert back func
    func alertBack(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
}
