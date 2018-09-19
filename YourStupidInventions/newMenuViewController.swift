//
//  newMenuViewController.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 9/2/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse
import XLPagerTabStrip

class newMenuViewController: ButtonBarPagerTabStripViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    // declare search bar
    var searchBar = UISearchBar()
    
    // tableView UI
    var tableView: UITableView = UITableView()
    
    var nounsIni = [String]()
    var nouns = [String]()
    var themeuuidArray = [String]()
    var titleArray = [String]()
    
    var lastSearchTime: CFAbsoluteTime!
    
    override func viewDidLoad() {
        
        // Bar font size
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 15)
        // Bar color
        settings.style.buttonBarBackgroundColor = customColorBrown
        // Button color
        settings.style.buttonBarItemBackgroundColor = customColorBrown
        // Cell text color
        settings.style.buttonBarItemTitleColor = UIColor.white
        // Select bar color
        settings.style.selectedBarBackgroundColor = customColorYellow
        
        // selected bar height
        settings.style.selectedBarHeight = 5
        
        
        // implement search bar
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.showsCancelButton = true
        searchBar.setValue(NSLocalizedString("Cancel", comment: ""), forKey: "_cancelButtonText")
        searchBar.placeholder = NSLocalizedString("Search", comment: "")
        searchBar.tintColor = UIColor.groupTableViewBackground
        searchBar.frame.size.width = self.view.frame.size.width - 30
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = searchItem
        
        // define tableView to list nouns
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 100)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
        // hide tableView
        tableView.isHidden = true
        
        // hide cancel button
        searchBar.showsCancelButton = false
        
        // avoid bottom white space in iPhone X
        // could be a better solution?
        containerView.frame.size.height = self.view.frame.size.height - (self.tabBarController?.tabBar.frame.size.height)! - (self.navigationController?.navigationBar.frame.size.height)!
        
        super.viewDidLoad()
    }

    
    // load nouns func
    func loadIniNoun() {
        
        nounsIni.removeAll(keepingCapacity: false)
        
        // update last search time
        lastSearchTime = CFAbsoluteTimeGetCurrent()
        
        print("newMenu initial search")
        let query = PFQuery(className: "themes")
        query.limit = 30
        query.addDescendingOrder("totalPosts")
        
        if !selectedLanguages.isEmpty {
            query.whereKey("language", containedIn: selectedLanguages)
        }
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                for object in objects! {
                    // append noun if not found in array
                    if (!self.nounsIni.contains(object.object(forKey: "noun") as! String) ||
                        object.object(forKey: "title") != nil ||
                        object.object(forKey: "themeuuid") != nil
                        ) {
                        self.nounsIni.append(object.object(forKey: "noun") as! String)
                        self.titleArray.append(object.object(forKey: "title") as! String)
                        self.themeuuidArray.append(object.object(forKey: "themeuuid") as! String)
                    }
                }
                
                // reload tableView and end refresh animation
                self.tableView.reloadData()
                
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    
    // search updated
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // allow new search every 2 seconds
        /* search every time a character is typed?
        let timeNow = CFAbsoluteTimeGetCurrent()
        if timeNow - lastSearchTime < 2 {
            return true
        }
        
        lastSearchTime = CFAbsoluteTimeGetCurrent()
        */
        
        nouns.removeAll(keepingCapacity: false)
        
        print("newMenu search")
        let query = PFQuery(className: "themes")
        query.limit = 30
        query.addDescendingOrder("totalPosts")
        query.whereKey("noun", matchesRegex: "(?i)" + self.searchBar.text!)
        
        if !selectedLanguages.isEmpty {
            query.whereKey("language", containedIn: selectedLanguages)
        }
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                for object in objects! {
                    // append noun if not found in array
                    if !self.nouns.contains(object.object(forKey: "noun") as! String) {
                        self.nouns.append(object.object(forKey: "noun") as! String)
                    }
                }
                
                // reload tableView and end refresh animation
                self.tableView.reloadData()
                
            } else {
                print(error!.localizedDescription)
            }
        }
        
        return true
    }
    
    // typed in the search bar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        // hide tableView when started typing
        tableView.isHidden = false
        
        // show cancel button
        searchBar.showsCancelButton = true
        
        // load initial nouns
        loadIniNoun()
    }
    
    
    // cicked cancel button
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        // hide tableView when canceled
        tableView.isHidden = true
        
        // dismiss keyboard
        searchBar.resignFirstResponder()
        
        // hide cancel button
        searchBar.showsCancelButton = false
        
        // reset nouns array
        nouns.removeAll(keepingCapacity: false)
        
        // reset text
        searchBar.text = ""
    }
    
    
    // cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    // cell number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nouns.isEmpty {
            return nounsIni.count
        } else {
            return nouns.count
        }
    }
    
    // cell config
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // define cell
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        // creates label only first time to avoid overlapping labels
        if let label = cell.viewWithTag(100) as? UILabel {
            if nouns.isEmpty {
                label.text = nounsIni[indexPath.row]
            } else {
                label.text = nouns[indexPath.row]
            }
        } else {
            // define label
            let label = UILabel(frame: CGRect(x: 20, y: 0, width: self.view.frame.size.width - 40, height: 40))
            label.tag = 100
            label.font = UIFont.systemFont(ofSize: 15)
            
            if nouns.isEmpty {
                label.text = nounsIni[indexPath.row]
            } else {
                label.text = nouns[indexPath.row]
            }
            
            cell.addSubview(label)
        }
        
        return cell
    }
    
    
    // selected tableView cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        /*
        // Option 1. Show rankingVC with the selected noun
        let result = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        
        result.sortBy = "createdAt"
        
        if nouns.isEmpty {
            result.filterByNoun = nounsIni[indexPath.row]
            result.navigationItem.title = nounsIni[indexPath.row]
        } else {
            result.filterByNoun = nouns[indexPath.row]
            result.navigationItem.title = nouns[indexPath.row]
        }*/
        
        // Option2. Show postIdeaVC with the selected noun
        themeuuid.append(themeuuidArray[indexPath.row])
        themetitle.append(titleArray[indexPath.row])
        
        // present postIdeaVC
        let result = self.storyboard?.instantiateViewController(withIdentifier: "postIdeaVC") as! postIdeaVC
        
        // hide tableView when canceled
        tableView.isHidden = true
        
        // dismiss keyboard
        searchBar.resignFirstResponder()
        
        // hide cancel button
        searchBar.showsCancelButton = false
        
        // reset nouns array
        nouns.removeAll(keepingCapacity: false)
        
        // reset text
        searchBar.text = ""
        
        self.navigationController?.pushViewController(result, animated: true)
    }
    
    
    // after view appears
    override func viewDidAppear(_ animated: Bool) {
        
        // move to All tab
        // moveToViewController(at: 3, animated: false)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        // Return added viewControllers
        let allVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        allVC.itemInfo = NSLocalizedString("All", comment: "")
        allVC.sortBy = "createdAt"
        
        let cat1VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        cat1VC.itemInfo = NSLocalizedString("Appliance", comment: "")
        cat1VC.sortBy = "createdAt"
        cat1VC.filterByCategory = "Appliance"
        
        let cat2VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        cat2VC.itemInfo = NSLocalizedString("Software", comment: "")
        cat2VC.sortBy = "createdAt"
        cat2VC.filterByCategory = "Software"
        
        let cat3VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        cat3VC.itemInfo = NSLocalizedString("Food", comment: "")
        cat3VC.sortBy = "createdAt"
        cat3VC.filterByCategory = "Food"
        
        let cat4VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        cat4VC.itemInfo = NSLocalizedString("Entertainment", comment: "")
        cat4VC.sortBy = "createdAt"
        cat4VC.filterByCategory = "Entertainment"
        
        let cat5VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        cat5VC.itemInfo = NSLocalizedString("Sports", comment: "")
        cat5VC.sortBy = "createdAt"
        cat5VC.filterByCategory = "Sports"
        
        let cat6VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        cat6VC.itemInfo = NSLocalizedString("Others", comment: "")
        cat6VC.sortBy = "createdAt"
        cat6VC.filterByCategory = "Others"
        
        let adj1VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        adj1VC.itemInfo = NSLocalizedString("Innovative", comment: "")
        adj1VC.filterByAdj = "Innovative"
        adj1VC.sortBy = "createdAt"
        adj1VC.filterByAdj = "Innovative"
        
        let adj2VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        adj2VC.itemInfo = NSLocalizedString("Unexpected", comment: "")
        adj2VC.sortBy = "createdAt"
        adj2VC.filterByAdj = "Unexpected"
        
        let adj3VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        adj3VC.itemInfo = NSLocalizedString("Future", comment: "")
        adj3VC.sortBy = "createdAt"
        adj3VC.filterByAdj = "Future"
        
        let childViewControllers:[UIViewController] = [allVC, cat1VC, cat2VC, cat3VC, cat4VC, cat5VC, cat6VC]
        
        return childViewControllers
    }
    
}
