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
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchAllPosts), name: didSharePostNotification, object: nil)
        
        collectionView.backgroundColor = .white
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: kCELLID)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        collectionView.refreshControl = refreshControl
        
        setupNavigationItem()
        
        fetchAllPosts()
    }
    
    fileprivate func setupNavigationItem() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
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
        
        if indexPath.item < posts.count { cell.post = posts[indexPath.item] }

        return cell
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
        self.collectionView.refreshControl?.endRefreshing()
        self.collectionView.reloadData()
    }
    
    @objc fileprivate func fetchAllPosts() {
        fetchPosts()
        fetchFollowingPosts()
    }
    
    @objc func handleRefresh() {
        posts.removeAll()
        fetchAllPosts()
    }
    
    @objc func handleCamera() {
        let cameraController = CameraController()
        present(cameraController, animated: true, completion: nil)
    }
}
