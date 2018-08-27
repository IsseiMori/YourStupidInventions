//
//  commentVC.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/26/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse

// global variables to store the post data
var commentuuid = [String]()
var commentowner = [String]()

class commentVC: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // present commentHeaderCell as header
        let headerCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "commentHeaderCell") as! commentHeaderCell
        let headerView: UIView = headerCell.contentView
        tableView.tableHeaderView = headerView
        
        // call alignment func
        alignment()
    }
    
    
    // alignment func
    func alignment() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // margin on the top
        tableView.frame.origin.y = 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! commentCell
        return cell
    }

}
