//
//  newMenuViewController.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 9/2/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class newMenuViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {

        // top title
        self.navigationItem.title = "New Ideas"
        
        // Bar color
        settings.style.buttonBarBackgroundColor = UIColor(red: 73/255, green: 72/255, blue: 62/255, alpha: 1)
        // Button color
        settings.style.buttonBarItemBackgroundColor = UIColor(red: 73/255, green: 72/255, blue: 62/255, alpha: 1)
        // Cell text color
        settings.style.buttonBarItemTitleColor = UIColor.white
        // Select bar color
        settings.style.selectedBarBackgroundColor = UIColor(red: 254/255, green: 0, blue: 124/255, alpha: 1)
        
        settings.style.buttonBarHeight = 50
        
        super.viewDidLoad()
    }

    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        // Return added viewControllers
        let allVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        allVC.itemInfo = "All"
        allVC.sortBy = "createdAt"
        allVC.filterBy = ""
        
        let cat1VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        cat1VC.itemInfo = "Appliance"
        cat1VC.sortBy = "createdAt"
        cat1VC.filterBy = ""
        
        let cat2VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        cat2VC.itemInfo = "Software"
        cat2VC.sortBy = "createdAt"
        cat2VC.filterBy = ""
        
        let cat3VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        cat3VC.itemInfo = "Entertainment"
        cat3VC.sortBy = "createdAt"
        cat3VC.filterBy = ""
        
        let cat4VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        cat4VC.itemInfo = "Sports"
        cat4VC.sortBy = "createdAt"
        cat4VC.filterBy = ""
        
        let cat5VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        cat5VC.itemInfo = "Others"
        cat5VC.sortBy = "createdAt"
        cat5VC.filterBy = ""
        
        let adj1VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        adj1VC.itemInfo = "Innovative"
        adj1VC.sortBy = "createdAt"
        adj1VC.filterBy = ""
        
        let adj2VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        adj2VC.itemInfo = "Unexpected"
        adj2VC.sortBy = "createdAt"
        adj2VC.filterBy = ""
        
        let childViewControllers:[UIViewController] = [adj1VC, adj2VC, allVC, cat1VC, cat2VC, cat3VC, cat4VC, cat5VC]
        
        return childViewControllers
    }
    
}
