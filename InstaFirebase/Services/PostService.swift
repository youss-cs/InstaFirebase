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
    
    func fetchProfilePostsFromFirestore(completion: @escaping(_ posts: [Post]) -> ()){
        var posts = [Post]()
        let userId = AuthService.instance.currentId()
        reference(.Posts).whereField(kUSERID, isEqualTo: userId).getDocuments() { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            for document in snapshot.documents {
                var data = document.data()
                data[kID] = document.documentID
                if let post = Post(dictionary: data) {
                    posts.append(post)
                }
            }
            completion(posts)
        }
    }
    
    func fetchPostsFromFirestore(completion: @escaping(_ posts: [Post]) -> ()){
        var posts = [Post]()
        reference(.Posts).getDocuments() { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            for document in snapshot.documents {
                var data = document.data()
                data[kID] = document.documentID
                if let post = Post(dictionary: data) {
                    posts.append(post)
                }
            }
            completion(posts)
        }
    }
    
}
