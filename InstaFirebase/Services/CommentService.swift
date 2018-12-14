//
//  CommentService.swift
//  InstaFirebase
//
//  Created by YouSS on 12/14/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

class CommentService {
    static let instance = CommentService()
    
    func saveCommentToFirestore(comment: Comment, completion: @escaping (_ error: Error?) -> Void) {
        reference(.Comments).document().setData(comment.dictionary) { (error) in
            completion(error)
        }
    }
    
    func fetchComments(postId: String, completion: @escaping (_ comments: [Comment]) -> Void) {
        reference(.Comments).whereField(kPOSTID, isEqualTo: postId).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            guard let user = AuthService.instance.currentUser() else { return }
            let comments = snapshot.documents.compactMap{ Comment(dictionary: $0.dataWithId(), user: user) }
            completion(comments)
        }
    }
}
