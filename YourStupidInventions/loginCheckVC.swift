//
//  loginCheckVC.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/30/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit

class loginCheckVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.string(forKey: "username") == nil {
            let signIn = self.storyboard?.instantiateViewController(withIdentifier: "signInVC") as! signInVC
            self.navigationController?.pushViewController(signIn, animated: true)
        } else {
            let home = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! homeVC
            self.navigationController?.pushViewController(home, animated: true)
        }
    }


}
