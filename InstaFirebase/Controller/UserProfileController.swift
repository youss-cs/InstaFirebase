//
//  UserProfileController.swift
//  InstaFirebase
//
//  Created by YouSS on 12/6/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import UIKit

class UserProfileController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        if let user = AuthService.instance.currentUser() {
            navigationItem.title =  user.username
        }
    }
}
