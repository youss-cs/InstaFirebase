//
//  CommentsController.swift
//  InstaFirebase
//
//  Created by YouSS on 12/14/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import UIKit

class CommentsController: UITableViewController {
    
    var post: Post?
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sendButton.setTitleColor(.black, for: .normal)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        containerView.addSubview(commentTextField)
        containerView.addSubview(sendButton)
        
        commentTextField.anchor(top: containerView.topAnchor, left: containerView.leadingAnchor, bottom: containerView.bottomAnchor, right: sendButton.leadingAnchor, paddingLeft: 12)
        sendButton.anchor(top: containerView.topAnchor, bottom: containerView.bottomAnchor, right: containerView.trailingAnchor, paddingRight: 12, width: 50)
        
        return containerView
    }()
    
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter comment"
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Comments"
        tableView.backgroundColor = .red
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    override var inputAccessoryView: UIView? {
        return containerView
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc func handleSend() {
        guard let user = AuthService.instance.currentUser() else { return }
        guard let post = post, let text = commentTextField.text else { return }
        guard let postId = post.id else { return }
        
        let dictionary : [String : Any] = [
            kTEXT : text,
            kCREATEDAT : Date(),
            kPOSTID : postId
        ]
        
        guard let comment = Comment(dictionary: dictionary, user: user) else { return }
        CommentService.instance.saveCommentToFirestore(comment: comment, completion: { (error) in
            if let error = error {
                print("Failed to save comment ", error)
                return
            }
            
            print("Comment successfully saved")
        })
    }
}
