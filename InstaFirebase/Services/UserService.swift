//
//  UserService.swift
//  InstaFirebase
//
//  Created by YouSS on 12/12/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import Firebase

class UserService {
    
    static let instance = UserService()
    
    //MARK: Fetch User funcs
    
    func fetchUser(userId: String, completion: @escaping (_ user: User) -> Void) {
        reference(.Users).document(userId).getDocument { (document, error) in
            guard let document = document, document.exists else { return }
            guard let dictionary = document.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    func fetchUsers(completion: @escaping (_ users: [User]) -> Void) {
        guard let loggedUserId = AuthService.instance.currentUser()?.id else { return }
        
        var users = [User]()
        reference(.Users).order(by: "username").getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            for document in snapshot.documents {
                if document.documentID != loggedUserId {
                    let user = User(dictionary: document.dataWithId())
                    users.append(user)
                }
            }
            completion(users)
        }
    }
    
    func follow(followerId: String, completion: @escaping () -> Void) {
        guard let userId = AuthService.instance.currentUser()?.id else { return }
        reference(.Following).document("\(userId)/Follower/\(followerId)").setData(["exist" : true]) { (error) in
            if error == nil {
                completion()
            }
        }
    }
    
    func unFollow(followerId: String, completion: @escaping () -> Void) {
        guard let userId = AuthService.instance.currentUser()?.id else { return }
        reference(.Following).document("\(userId)/Follower/\(followerId)").delete { (error) in
            if error == nil {
                completion()
            }
        }
    }
    
    func checkFollower(followerId: String, completion: @escaping (_ isFollowing: Bool) -> Void) {
        guard let userId = AuthService.instance.currentUser()?.id else { return }
        reference(.Following).document(userId).collection("Follower").document(followerId).getDocument { (document, error) in
            guard let document = document else { return }
            completion(document.exists)
        }
    }
}
