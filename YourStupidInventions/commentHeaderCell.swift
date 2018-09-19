//
//  commentHeaderCell.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/26/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse

class commentHeaderCell: UITableViewCell{

    // theme picture
    @IBOutlet weak var themeImg: UIImageView!
    
    // labels
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var ideaLbl: UILabel!
    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var ptLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var uuidLbl: UILabel!
    @IBOutlet weak var themeuuid: UILabel!
    
    // buttons
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var usernameBtn: UIButton!
    @IBOutlet weak var postIdeaBtn: UIButton!
    
    @IBOutlet weak var bgView: UIView!
    
    var delegate: UIViewController?
    
    // default
    override func awakeFromNib() {
        super.awakeFromNib()

        // call align func
        alignment()
    }
    
    
    // alignment func
    func alignment() {
        
        let width = UIScreen.main.bounds.width
        
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        themeImg.translatesAutoresizingMaskIntoConstraints = false
        ideaLbl.translatesAutoresizingMaskIntoConstraints = false
        likeLbl.translatesAutoresizingMaskIntoConstraints = false
        ptLbl.translatesAutoresizingMaskIntoConstraints = false
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        uuidLbl.translatesAutoresizingMaskIntoConstraints = false
        likeBtn.translatesAutoresizingMaskIntoConstraints = false
        usernameBtn.translatesAutoresizingMaskIntoConstraints = false
        bgView.translatesAutoresizingMaskIntoConstraints = false
        postIdeaBtn.translatesAutoresizingMaskIntoConstraints = false
        
        let themeWidth = width - 40
        let themeHeight = themeWidth / 16 * 9
        
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-20-[title]-10-[theme(\(themeHeight))]-10-[idea]-(-10)-[like(70)]-5-[post(30)]-10-|",
            options: [], metrics: nil, views: ["title": titleLbl, "theme": themeImg, "idea": ideaLbl, "like": likeBtn, "post": postIdeaBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[idea]-20-[likes]",
            options: [], metrics: nil, views: ["idea": ideaLbl, "likes": likeLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[idea]-20-[pt]",
            options: [], metrics: nil, views: ["idea": ideaLbl, "pt": ptLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[idea]-15-[username]",
            options: [], metrics: nil, views: ["idea": ideaLbl, "username": usernameBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[idea]-22-[date]",
            options: [], metrics: nil, views: ["idea": ideaLbl, "date": dateLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[title]-15-|",
            options: [], metrics: nil, views: ["title": titleLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[theme]-15-|",
            options: [], metrics: nil, views: ["theme": themeImg]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[theme]-15-|",
            options: [], metrics: nil, views: ["theme": themeImg]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-25-[idea]-25-|",
            options: [], metrics: nil, views: ["idea": ideaLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[like(70)]-10-[likes]-[pt]",
            options: [], metrics: nil, views: ["like": likeBtn, "likes": likeLbl, "pt": ptLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[username]-10-[date]-25-|",
            options: [], metrics: nil, views: ["username": usernameBtn, "date":dateLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[post]-10-|",
            options: [], metrics: nil, views: ["post": postIdeaBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[bg]-55-|",
            options: [], metrics: nil, views: ["bg": bgView]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[bg]-10-|",
            options: [], metrics: nil, views: ["bg": bgView]))
        
        
        bgView.layer.zPosition = -1
        bgView.layer.cornerRadius = self.frame.size.width / 30
        bgView.clipsToBounds = true
        bgView.backgroundColor = .white
        
        likeBtn.setTitle("unlike", for: UIControlState.normal)
        
        // clear like button text color
        likeBtn.setTitleColor(UIColor.clear, for: UIControlState.normal)
        
        postIdeaBtn.backgroundColor = customColorYellow
        postIdeaBtn.layer.cornerRadius = 5
        
        postIdeaBtn.setTitle(NSLocalizedString("Post your idea to this theme", comment: ""), for: UIControlState.normal)
    }
    
    // alert back func
    func alertBack(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (UIAlertAction) in
            self.delegate?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(ok)
        delegate?.present(alert, animated: true, completion: nil)
    }

}
