//
//  CommentsController.swift
//  InstaFirebase
//
//  Created by YouSS on 12/14/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UITableViewController {
    
    var post: Post?
    var comments = [Comment]()
    
    lazy var containerView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
        commentInputAccessoryView.delegate = self
        return commentInputAccessoryView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Comments"
        setupTableView()
        
        fetchComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCELLID, for: indexPath) as! CommentCell
        cell.comment = comments[indexPath.row]
        return cell
    }
    
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView()
        tableView.register(CommentCell.self, forCellReuseIdentifier: kCELLID)
    }
    
    func fetchComments() {
        guard let postId = post?.id else { return }
        reference(.Comments).whereField(kPOSTID, isEqualTo: postId).addSnapshotListener { (snapshot, erro) in
            guard let snapshot = snapshot else { return }
            snapshot.documentChanges.forEach({ (change) in
                self.handleDocumentChange(change: change)
            })
        }
    }
    
    func handleDocumentChange(change: DocumentChange) {
        let dictionary = change.document.data()
        guard let userId = dictionary[kUSERID] as? String else { return }
        
        UserService.instance.fetchUser(userId: userId) { (user) in
            guard let comment = Comment(dictionary: dictionary, user: user) else { return }
            
            switch change.type {
            case .added:
                self.comments.append(comment)
                let indexPath = IndexPath(row: self.comments.count - 1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            default:
                break
            }
        }
    }
}

extension CommentsController: CommentInputAccessoryViewDelegate {
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func didSubmit(for comment: String) {
        guard let user = AuthService.instance.currentUser() else { return }
        guard let postId = post?.id else { return }
        
        let dictionary: [String : Any] = [
            kTEXT : comment,
            kPOSTID : postId,
            kCREATEDAT : Date()
        ]
        
        guard let comment = Comment(dictionary: dictionary, user: user) else { return }
        CommentService.instance.saveCommentToFirestore(comment: comment) { (error) in
            if error != nil {
                return
            }
        }
    }
}
