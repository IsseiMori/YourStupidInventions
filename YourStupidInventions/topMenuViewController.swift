//
//  topMenuViewController.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 9/2/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class topMenuViewController: ButtonBarPagerTabStripViewController {
    
    override func viewDidLoad() {
        
        // top title
        self.navigationItem.title = NSLocalizedString("Top Ideas", comment: "")
        
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
        
        // avoid bottom white space in iPhone X
        // could be a better solution?
        containerView.frame.size.height = self.view.frame.size.height - (self.tabBarController?.tabBar.frame.size.height)! - (self.navigationController?.navigationBar.frame.size.height)!
        
        super.viewDidLoad()
        
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
        allVC.sortBy = "likes"
        
        let cat1VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        cat1VC.itemInfo = NSLocalizedString("Appliance", comment: "")
        cat1VC.sortBy = "likes"
        cat1VC.filterByCategory = "Appliance"
        
        let cat2VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        cat2VC.itemInfo = NSLocalizedString("Software", comment: "")
        cat2VC.sortBy = "likes"
        cat2VC.filterByCategory = "Software"
        
        let cat3VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        cat3VC.itemInfo = NSLocalizedString("Food", comment: "")
        cat3VC.sortBy = "likes"
        cat3VC.filterByCategory = "Food"
        
        let cat4VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        cat4VC.itemInfo = NSLocalizedString("Entertainment", comment: "")
        cat4VC.sortBy = "likes"
        cat4VC.filterByCategory = "Entertainment"
        
        let cat5VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        cat5VC.itemInfo = NSLocalizedString("Sports", comment: "")
        cat5VC.sortBy = "likes"
        cat5VC.filterByCategory = "Sports"
        
        let cat6VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        cat6VC.itemInfo = NSLocalizedString("Others", comment: "")
        cat6VC.sortBy = "likes"
        cat6VC.filterByCategory = "Others"
        
        let adj1VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        adj1VC.itemInfo = NSLocalizedString("Innovative", comment: "")
        adj1VC.filterByAdj = "Innovative"
        adj1VC.sortBy = "likes"
        adj1VC.filterByAdj = "Innovative"
        
        let adj2VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        adj2VC.itemInfo = NSLocalizedString("Unexpected", comment: "")
        adj2VC.sortBy = "likes"
        adj2VC.filterByAdj = "Unexpected"
        
        let adj3VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        adj3VC.itemInfo = NSLocalizedString("Future", comment: "")
        adj3VC.sortBy = "likes"
        adj3VC.filterByAdj = "Future"
        
        let childViewControllers:[UIViewController] = [allVC, cat1VC, cat2VC, cat3VC, cat4VC, cat5VC, cat6VC]
        
        
        return childViewControllers
    }
    
}
