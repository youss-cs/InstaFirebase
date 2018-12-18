//
//  CommentInputAccessoryView.swift
//  InstaFirebase
//
//  Created by YouSS on 12/18/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import UIKit

protocol CommentInputAccessoryViewDelegate {
    func didSubmit(for comment: String)
}

class CommentInputAccessoryView: UIView {
    
    var delegate: CommentInputAccessoryViewDelegate?
    
    func clearCommentTextField() {
        commentTextField.text = nil
    }
    
    fileprivate let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Comment"
        return textField
    }()
    
    fileprivate let submitButton: UIButton = {
        let sb = UIButton(type: .system)
        sb.setTitle("Submit", for: .normal)
        sb.setTitleColor(.black, for: .normal)
        sb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sb.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return sb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(submitButton)
        submitButton.anchor(top: topAnchor, bottom: bottomAnchor, right: trailingAnchor, paddingRight: 12, width: 50)
        
        addSubview(commentTextField)
        commentTextField.anchor(top: topAnchor, left: leadingAnchor, bottom: bottomAnchor, right: submitButton.leadingAnchor, paddingLeft: 8)
        
        setupLineSeparatorView()
    }
    
    fileprivate func setupLineSeparatorView() {
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.rgb(230, 230, 230)
        addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: topAnchor, left: leadingAnchor, right: trailingAnchor, height: 0.5)
    }
    
    @objc func handleSubmit() {
        guard let commentText = commentTextField.text else { return }
        delegate?.didSubmit(for: commentText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
