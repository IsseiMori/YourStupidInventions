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

class commentVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let headerCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "commentHeaderCell") as! commentHeaderCell
        let headerView: UIView = headerCell.contentView
        tableView.tableHeaderView = headerView
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}
