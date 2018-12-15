//
//  PostService.swift
//  InstaFirebase
//
//  Created by YouSS on 12/9/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

class PostService {
    static let instance = PostService()
    
    func savePostToFirestore(post: Post, completion: @escaping (_ error: Error?) -> Void) {
        reference(.Posts).document().setData(post.dictionary) { (error) in
            completion(error)
        }
    }
    
    //MARK: Fetch posts funcs
    
    func fetchPostsWithUser(user: User, completion: @escaping (_ post: Post) -> Void) {
        reference(.Posts).whereField("userId", isEqualTo: user.id).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            snapshot.documents.forEach({ (document) in
                guard var post = Post(user: user, dictionary: document.dataWithId()) else { return }
                guard let postId = post.id else { return }
                self.checkLike(postId: postId, completion: { (isLiked) in
                    post.hasLiked = isLiked
                    completion(post)
                })
            })
        }
    }
    
    func fetchFollowingPosts(completion: @escaping (_ post: Post) -> Void) {
        guard let userId = AuthService.instance.currentUser()?.id else { return }
        
        reference(.Following).document(userId).collection("Follower").getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            snapshot.documents.forEach({ (document) in
                UserService.instance.fetchUser(userId: document.documentID, completion: { (user) in
                    self.fetchPostsWithUser(user: user, completion: { (post) in
                        completion(post)
                    })
                })
            })
        }
    }
    
    func toggleLike(post: Post, completion: @escaping (_ error: Error?) -> Void) {
        guard let userId = AuthService.instance.currentUser()?.id else { return }
        guard let postId = post.id else { return }
        
        let data = ["exist" : !post.hasLiked]
        
        reference(.Likes).document("\(postId)/Users/\(userId)").setData(data) { (error) in
            completion(error)
        }
    }
    
    func checkLike(postId: String, completion: @escaping (_ isLiked: Bool) -> Void) {
        guard let userId = AuthService.instance.currentUser()?.id else { return }
        reference(.Likes).document("\(postId)/Users/\(userId)").getDocument { (document, error) in
            if error != nil {
                return
            }
            
            let data = document?.data()
            guard let exist = data?["exist"] as? Bool else {
                completion(false)
                return
            }
            
            completion(exist)
        }
    }
    
}
