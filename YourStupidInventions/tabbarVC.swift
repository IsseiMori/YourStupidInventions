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
        
        

        // Do any additional setup after loading the view.
    }
    


}
