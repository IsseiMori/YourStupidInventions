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
        self.navigationItem.title = "Top Ideas"
        
        // Bar color
        settings.style.buttonBarBackgroundColor = UIColor(red: 73/255, green: 72/255, blue: 62/255, alpha: 1)
        // Button color
        settings.style.buttonBarItemBackgroundColor = UIColor(red: 73/255, green: 72/255, blue: 62/255, alpha: 1)
        // Cell text color
        settings.style.buttonBarItemTitleColor = UIColor.white
        // Select bar color
        settings.style.selectedBarBackgroundColor = UIColor(red: 255.0 / 255.0, green: 189.0 / 255.0, blue: 0.0 / 255.0, alpha: 1)
        
        settings.style.buttonBarHeight = 50
        
        super.viewDidLoad()
        
    }
    
    // after view appears
    override func viewDidAppear(_ animated: Bool) {
        
        // move to All tab
        moveToViewController(at: 2, animated: false)
    }
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        // Return added viewControllers
        let allVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        allVC.itemInfo = "All"
        allVC.sortBy = "likes"
        allVC.filterBy = ""
        
        let cat1VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        cat1VC.itemInfo = "Appliance"
        cat1VC.sortBy = "likes"
        cat1VC.filterBy = ""
        
        let cat2VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        cat2VC.itemInfo = "Software"
        cat2VC.sortBy = "likes"
        cat2VC.filterBy = ""
        
        let cat3VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        cat3VC.itemInfo = "Entertainment"
        cat3VC.sortBy = "likes"
        cat3VC.filterBy = ""
        
        let cat4VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        cat4VC.itemInfo = "Sports"
        cat4VC.sortBy = "likes"
        cat4VC.filterBy = ""
        
        let cat5VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        cat5VC.itemInfo = "Others"
        cat5VC.sortBy = "likes"
        cat5VC.filterBy = ""
        
        let adj1VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        adj1VC.itemInfo = "Innovative"
        adj1VC.sortBy = "likes"
        adj1VC.filterBy = ""
        
        let adj2VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rankingVC") as! rankingVC
        adj2VC.itemInfo = "Unexpected"
        adj2VC.sortBy = "likes"
        adj2VC.filterBy = ""
        
        let childViewControllers:[UIViewController] = [adj1VC, adj2VC, allVC, cat1VC, cat2VC, cat3VC, cat4VC, cat5VC]
        
        
        return childViewControllers
    }
    
}
