//
//  tutorialVC.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 9/17/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit

class tutorialVC: UIViewController, UIScrollViewDelegate {

    var scrollView: UIScrollView!
    var pageControll: UIPageControl!
    let pageNum = 5
    let pageColors:[Int:UIColor] = [1:UIColor.red,2:UIColor.yellow,3:UIColor.blue,4:UIColor.green]
    let pageLbls:[Int:String] = [1:NSLocalizedString("tutorial page 1", comment: ""),
                                 2:NSLocalizedString("tutorial page 2", comment: ""),
                                 3:NSLocalizedString("tutorial page 3", comment: ""),
                                 4:NSLocalizedString("tutorial page 4", comment: ""),
                                 5:NSLocalizedString("tutorial page 5", comment: "")]
    var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView = UIScrollView(frame: self.view.bounds)
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(pageNum), height: self.view.bounds.height)
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.delegate = self;
        self.view.addSubview(self.scrollView)
        
        self.pageControll = UIPageControl(frame: CGRect(x: 0, y: self.view.bounds.height - 150, width: self.view.bounds.width, height: 50))
        self.pageControll.numberOfPages = pageNum
        self.pageControll.currentPage = 0
        self.view.addSubview(self.pageControll)
        
        
        // done button
        button = UIButton(frame: CGRect(x: 0, y: self.view.bounds.height - 80, width: self.view.bounds.width * 0.8, height: 50))
        button.center.x = self.view.bounds.width * 0.5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(self.doneBtn_clicked), for:.touchUpInside)
        button.layer.cornerRadius = 5
        button.setTitle(NSLocalizedString("skip tutorial", comment: ""), for: UIControlState.normal)
        self.view.addSubview(button)
        
        for p in 1...pageNum {
            let v = UIView(frame: CGRect(x: self.view.bounds.width * CGFloat(p-1), y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
            v.backgroundColor = customColorYellow
            
            let textLbl = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.8, height: 100))
            textLbl.center.x = self.view.bounds.width / 2
            textLbl.center.y = self.view.bounds.height / 2
            textLbl.textAlignment = .center
            textLbl.textColor = .white
            textLbl.numberOfLines = 5
            textLbl.text = pageLbls[p]
            
            v.addSubview(textLbl)
            self.scrollView.addSubview(v)
        }
    }
    
    @objc func doneBtn_clicked(sender: UIButton) {
        self.performSegue(withIdentifier: "tutorialToMain", sender: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageProgress = Double(scrollView.contentOffset.x / scrollView.bounds.width)
        self.pageControll.currentPage = Int(round(pageProgress))
        
        if self.pageControll.currentPage == pageNum - 1{
            button.setTitle(NSLocalizedString("done tutorial", comment: ""), for: UIControlState.normal)
        } else {
            button.setTitle(NSLocalizedString("skip tutorial", comment: ""), for: UIControlState.normal)
        }
        
    }

}
