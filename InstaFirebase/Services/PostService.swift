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
    
    func fetchPostsWithUser(user: User, completion: @escaping (_ posts: [Post]) -> Void) {
        reference(.Posts).whereField("userId", isEqualTo: user.id).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            let posts = snapshot.documents.compactMap{ Post(user: user, dictionary: $0.dataWithId()) }
            completion(posts)
        }
    }
    
    func fetchFollowingPosts(completion: @escaping (_ posts: [Post]) -> Void) {
        guard let userId = AuthService.instance.currentUser()?.id else { return }
        
        reference(.Following).document(userId).collection("Follower").getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            snapshot.documents.forEach({ (document) in
                UserService.instance.fetchUser(userId: document.documentID, completion: { (user) in
                    self.fetchPostsWithUser(user: user, completion: { (posts) in
                        completion(posts)
                    })
                })
            })
        }
    }
    
}
