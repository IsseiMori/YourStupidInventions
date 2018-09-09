//
//  settingVC.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 9/9/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse
import Eureka

class settingVC: FormViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let editVC = storyboard.instantiateViewController(withIdentifier: "editVC") as! editVC

        form +++ Section("Profile")
            <<< LabelRow() {
                $0.title = "Edit profile"
                }.onCellSelection { (str, row) in
                    self.navigationController?.pushViewController(editVC, animated: true)
                }.cellUpdate { (cell, row) in
                    cell.accessoryType = .disclosureIndicator
                }
        
        form +++ Section()
            <<< ButtonRow() {
                $0.title = "Log out"
                }.onCellSelection({ (cell, row) in
                    
                    PFUser.logOutInBackground { (error) in
                        if error == nil {
                            
                            // remove logged in username from app memory
                            UserDefaults.standard.removeObject(forKey: "username")
                            UserDefaults.standard.synchronize()
                            
                            isLoggedIn = false
                            
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                })
        
    }

}
