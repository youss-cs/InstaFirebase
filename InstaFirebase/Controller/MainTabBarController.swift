//
//  MainTabBarController.swift
//  InstaFirebase
//
//  Created by YouSS on 12/6/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let userProfile = UserProfileController(collectionViewLayout: layout)
        let nav = UINavigationController(rootViewController: userProfile)
        
        viewControllers = [nav]
        
        nav.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        nav.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        tabBar.tintColor = .black
    }
}
