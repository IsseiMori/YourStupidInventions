//
//  settingVC.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 9/9/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
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
        
    }

}
