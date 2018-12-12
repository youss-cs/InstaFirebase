//
//  HomeController.swift
//  InstaFirebase
//
//  Created by YouSS on 12/10/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: kCELLID)
        
        setupNavigationItem()
        
        fetchPosts()
        fetchFollowingPosts()
    }
    
    fileprivate func fetchPosts() {
        guard let user = AuthService.instance.currentUser() else { return }
        PostService.instance.fetchPostsWithUser(user: user) { (posts) in
            self.reloadCollection(posts: posts)
        }
    }
    
    fileprivate func fetchFollowingPosts() {
        PostService.instance.fetchFollowingPosts { (posts) in
            self.reloadCollection(posts: posts)
        }
    }
    
    fileprivate func reloadCollection(posts: [Post]) {
        self.posts += posts
        self.posts.sort{ $0.createdAt > $1.createdAt }
        self.collectionView.reloadData()
    }
    
    fileprivate func setupNavigationItem() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 40 + 8 + 8
        height += view.frame.width
        height += 50
        height += 60
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCELLID, for: indexPath) as! HomePostCell
        
        cell.post = posts[indexPath.item]
        return cell
    }
}
