//
//  navVC.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/26/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit

class navVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // color of title at the top of nav controller
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        // color of buttons in nav controller
        self.navigationBar.tintColor = .white
        
        // color of background of nav controller
        self.navigationBar.barTintColor = customColorYellow
        
        // disable translucent
        self.navigationBar.isTranslucent = false
        
    }
    
    // white status bar func
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    

}
