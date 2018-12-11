//
//  UserProfileController.swift
//  InstaFirebase
//
//  Created by YouSS on 12/6/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var user: User?
    var posts = [Post]()
    var postListener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = user ?? AuthService.instance.currentUser()
        
        collectionView.backgroundColor = .white
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHEADERID)
        collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: kCELLID)
        
        navigationItem.title = user?.username
        
        setupLogOutButton()
        fetchProfilePosts()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHEADERID, for: indexPath) as! UserProfileHeader
        header.user = user
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCELLID, for: indexPath) as! UserProfilePhotoCell
        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    fileprivate func setupLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    @objc func handleLogOut() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "LogOut", style: .destructive, handler: { (_) in
            AuthService.instance.logOutCurrentUser(completion: { (success) in
                if success {
                    let logInController = LoginController()
                    let navController = UINavigationController(rootViewController: logInController)
                    UIApplication.setRootView(navController)
                }
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func fetchProfilePosts() {
        guard let userId = user?.id else { return }
        postListener = reference(.Posts).whereField("userId", isEqualTo: userId).addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }
    }
    
    fileprivate func handleDocumentChange(_ change: DocumentChange) {
        let document = change.document
        var data = document.data()
        data[kID] = document.documentID
        guard let user = AuthService.instance.currentUser() else { return }
        guard let post = Post(user: user, dictionary: document.data()) else { return }
        
        switch change.type {
        case .added:
            posts.insert(post, at: 0)
            let indexPath = IndexPath(item: 0, section: 0)
            collectionView.insertItems(at: [indexPath])
        default:
            break
        }
    }
    
}
