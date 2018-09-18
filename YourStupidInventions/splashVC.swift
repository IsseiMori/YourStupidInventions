//
//  splashVC.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 9/17/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit

class splashVC: UIViewController {

    @IBOutlet weak var logoImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        // shrink animation
        UIView.animate(withDuration: 0.3,
                                   delay: 1.0,
                                   options: UIViewAnimationOptions.curveEaseOut,
                                   animations: { () in
                                    self.logoImg.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { (Bool) in
            
        })
        
        // expand and dissapear
        UIView.animate(withDuration: 0.2,
                                   delay: 1.3,
                                   options: UIViewAnimationOptions.curveEaseOut,
                                   animations: { () in
                                    self.logoImg.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                                    self.logoImg.alpha = 0
        }, completion: { (Bool) in
            self.logoImg.removeFromSuperview()
            
            // show tutorial only first time, show tabBar otherwise
            if UserDefaults.standard.value(forKey: "C_NSUSERDEFAULT_FIRST_TIME") != nil {
                self.performSegue(withIdentifier: "toMain", sender: nil)
            } else {
                self.performSegue(withIdentifier: "toTutorial", sender: nil)
            }
        })
    }

}
