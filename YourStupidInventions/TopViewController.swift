//
//  MainViewController.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 9/2/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import XLPagerTabStrip

var topMenuIndex: Int = 0


class TopViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {

        
        //バーの色
        settings.style.buttonBarBackgroundColor = UIColor(red: 73/255, green: 72/255, blue: 62/255, alpha: 1)
        //ボタンの色
        settings.style.buttonBarItemBackgroundColor = UIColor(red: 73/255, green: 72/255, blue: 62/255, alpha: 1)
        //セルの文字色
        settings.style.buttonBarItemTitleColor = UIColor.white
        //セレクトバーの色
        settings.style.selectedBarBackgroundColor = UIColor(red: 254/255, green: 0, blue: 124/255, alpha: 1)
        
        settings.style.buttonBarHeight = 50
        
        super.viewDidLoad()
    }

    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        // Return added viewControllers
        let firstVC = UIStoryboard(name: "Top ", bundle: nil).instantiateViewController(withIdentifier: "rankingVC")
        let secondVC = UIStoryboard(name: "Top", bundle: nil).instantiateViewController(withIdentifier: "rankingVC")
        let childViewControllers:[UIViewController] = [firstVC, secondVC]
        return childViewControllers
    }
    
}
