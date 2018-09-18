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
        
        // new back button
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.back))
        self.navigationItem.leftBarButtonItem = backBtn
        
        // swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.back))
        backSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(backSwipe)
        
        self.navigationItem.title = NSLocalizedString("Setting", comment: "")
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let editVC = storyboard.instantiateViewController(withIdentifier: "editVC") as! editVC
        let reportProblemVC = storyboard.instantiateViewController(withIdentifier: "reportProblemVC") as! reportProblemVC

        form +++ Section(NSLocalizedString("User", comment: ""))
            <<< LabelRow() {
                $0.title = NSLocalizedString("Edit profile", comment: "")
                }.onCellSelection { (str, row) in
                    self.navigationController?.pushViewController(editVC, animated: true)
                }.cellUpdate { (cell, row) in
                    cell.accessoryType = .disclosureIndicator
                }
            <<< MultipleSelectorRow<String>() {
                $0.title = NSLocalizedString("Language of shown posts", comment: "")
                $0.options = [NSLocalizedString("English", comment: ""),
                              NSLocalizedString("Japanese", comment: "")/*,
                              NSLocalizedString("Chinese", comment: "")*/]
                $0.selectorTitle = NSLocalizedString("Language of shown posts", comment: "")
                // check selected language by default
                $0.value = []
                for lang in selectedLanguages {
                    $0.value?.insert(NSLocalizedString(lang, comment: ""))
                }
                }.onChange { (row) in
                    // apply selected values to selectedLanguages and save it to device
                    selectedLanguages.removeAll(keepingCapacity: false)
                    for lang in row.value! {
                        switch row.options?.index(of: lang) {
                        case 0:
                            selectedLanguages.append("en")
                        case 1:
                            selectedLanguages.append("jp")
                        case 2:
                            selectedLanguages.append("ch")
                        default:
                            break
                        }
                    }
                    
                    // save
                    UserDefaults.standard.set(selectedLanguages, forKey: "selectedLanguages")
                    UserDefaults.standard.synchronize()
                }.onPresent({ (from, to) in
                    // new back button
                    to.navigationItem.hidesBackButton = true
                    let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.back))
                    to.navigationItem.leftBarButtonItem = backBtn
                    
                    // swipe to go back
                    let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.back))
                    backSwipe.direction = UISwipeGestureRecognizerDirection.right
                    to.view.addGestureRecognizer(backSwipe)
                    
                })
        
        form +++ Section(NSLocalizedString("App information", comment: ""))
            <<< LabelRow() {
                $0.title = NSLocalizedString("Report a problem", comment: "")
                }.onCellSelection { (str, row) in
                    self.navigationController?.pushViewController(reportProblemVC, animated: true)
                }.cellUpdate { (cell, row) in
                    cell.accessoryType = .disclosureIndicator
        }
        
        form +++ Section()
            <<< ButtonRow() {
                $0.title = NSLocalizedString("Log out", comment: "")
                }.onCellSelection { (cell, row) in
                    
                    PFUser.logOutInBackground { (error) in
                        if error == nil {
                            
                            // remove logged in username from app memory
                            UserDefaults.standard.removeObject(forKey: "username")
                            UserDefaults.standard.synchronize()
                            
                            isLoggedIn = false
                            
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }.cellUpdate { (cell, row) in
                    cell.textLabel?.textColor = .black
                }
        
    }
    
    @objc func back(sender: UIBarButtonItem) {
        
        // push back
        self.navigationController?.popViewController(animated: true)
    }
    
    // alert func
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

}
