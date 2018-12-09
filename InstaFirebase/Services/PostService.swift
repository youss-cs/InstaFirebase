//
//  PostService.swift
//  InstaFirebase
//
//  Created by YouSS on 12/9/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import Foundation

class PostService {
    static let instance = PostService()
    
    func savePostToFirestore(post: Post, completion: @escaping (_ error: Error?) -> Void) {
        reference(.Posts).document().setData(post.dictionary) { (error) in
            completion(error)
        }
    }
    
}
