//
//  homeVC.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/27/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse


class homeVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Home"


    }
    
    override func viewWillAppear(_ animated: Bool) {
        // go to log in if not yet signed in
        let username: String? = UserDefaults.standard.string(forKey: "username")
        
        if username == nil {
            let signIn = self.storyboard?.instantiateViewController(withIdentifier: "signInVC") as! signInVC
            self.navigationController?.pushViewController(signIn, animated: true)
        }
    }
    


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    
        // Configure the cell
    
        return cell
    }
    
    
    // header config
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // define header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "homeHeaderView", for: indexPath) as! homeHeaderView
        
        // get user data with connections to columns of PFUser class
        header.fullnameLbl.text = (PFUser.current()?.object(forKey: "fullname") as? String)?.uppercased()
        header.usernameLbl.text = PFUser.current()?.username!
        
        let avaQuery = PFUser.current()?.object(forKey: "ava") as! PFFile
        avaQuery.getDataInBackground { (data, error) in
            header.avaImg.image = UIImage(data: data!)
        }

        // count total posts
        let posts = PFQuery(className: "posts")
        posts.whereKey("username", equalTo: PFUser.current()!.username!)
        posts.countObjectsInBackground { (count, error) in
            if error == nil {
                header.ideas.text = "\(count)"
            }
        }
        
        // count total likes
        let likes = PFQuery(className: "likes")
        likes.whereKey("to", equalTo: PFUser.current()!.username!)
        likes.countObjectsInBackground { (count, error) in
            if error == nil {
                header.likes.text = "\(count)"
            }
        }

        
        return header
    }

    

}
