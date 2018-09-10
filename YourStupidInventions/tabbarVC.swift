//
//  tabbarVC.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/26/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit

class tabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // color of items
        self.tabBar.tintColor = .white
        
        // color of background
        self.tabBar.barTintColor = customColorLightBlack
        
        // disable translucent
        self.tabBar.isTranslucent = false
        
        // tabBar labels
        tabBar.items![0].title = NSLocalizedString("Top", comment: "")
        tabBar.items![1].title = NSLocalizedString("New", comment: "")
        tabBar.items![2].title = NSLocalizedString("Idea", comment: "")
        tabBar.items![3].title = NSLocalizedString("Notifications", comment: "")
        tabBar.items![4].title = NSLocalizedString("Home", comment: "")

    }
    


}
