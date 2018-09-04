//
//  themeMenuViewController.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 9/2/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class themeMenuViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {

        // top title
        self.navigationItem.title = "New Themes"
        
        // Bar font size
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 15)
        // Bar color
        settings.style.buttonBarBackgroundColor = UIColor(red: 73/255, green: 72/255, blue: 62/255, alpha: 1)
        // Button color
        settings.style.buttonBarItemBackgroundColor = UIColor(red: 73/255, green: 72/255, blue: 62/255, alpha: 1)
        // Cell text color
        settings.style.buttonBarItemTitleColor = UIColor.white
        // Select bar color
        settings.style.selectedBarBackgroundColor = UIColor(red: 255.0 / 255.0, green: 189.0 / 255.0, blue: 0.0 / 255.0, alpha: 1)
        
        // selected bar height
        settings.style.selectedBarHeight = 5
        
        super.viewDidLoad()
    }

    
    // after view appears
    override func viewDidAppear(_ animated: Bool) {
        
        // move to All tab
        moveToViewController(at: 3, animated: false)
    }
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        // Return added viewControllers
        let allVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "themesVC") as! themesVC
        allVC.itemInfo = "All"
        
        let cat1VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "themesVC") as! themesVC
        cat1VC.itemInfo = "Appliance"
        cat1VC.filterByCategory = "Appliance"
        
        let cat2VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "themesVC") as! themesVC
        cat2VC.itemInfo = "Software"
        cat2VC.filterByCategory = "Software"
        
        let cat3VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "themesVC") as! themesVC
        cat3VC.itemInfo = "Food"
        cat3VC.filterByCategory = "Food"
        
        let cat4VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "themesVC") as! themesVC
        cat4VC.itemInfo = "Entertainment"
        cat4VC.filterByCategory = "Entertainment"
        
        let cat5VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "themesVC") as! themesVC
        cat5VC.itemInfo = "Sports"
        cat5VC.filterByCategory = "Sports"
        
        let cat6VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "themesVC") as! themesVC
        cat6VC.itemInfo = "Others"
        cat6VC.filterByCategory = "Others"
        
        let adj1VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "themesVC") as! themesVC
        adj1VC.itemInfo = "Innovative"
        adj1VC.filterByAdj = "Innovative"
        
        let adj2VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "themesVC") as! themesVC
        adj2VC.itemInfo = "Unexpected"
        adj2VC.filterByAdj = "Unexpected"
        
        let adj3VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "themesVC") as! themesVC
        adj3VC.itemInfo = "Future"
        adj3VC.filterByAdj = "Future"
        
        let childViewControllers:[UIViewController] = [adj1VC, adj2VC, adj3VC, allVC, cat1VC, cat2VC, cat3VC, cat4VC, cat5VC, cat6VC]
        
        return childViewControllers
    }
    
}
