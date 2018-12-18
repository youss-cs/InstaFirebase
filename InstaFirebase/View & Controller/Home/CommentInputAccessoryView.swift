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
        commentTextView.text = nil
        commentTextView.showPlaceholderLabel()
    }
    
    fileprivate let commentTextView: CommentInputTextView = {
        let tv = CommentInputTextView()
        tv.isScrollEnabled = false
        tv.font = UIFont.systemFont(ofSize: 18)
        return tv
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
        
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
        
        addSubview(submitButton)
        submitButton.anchor(top: topAnchor, right: trailingAnchor, paddingRight: 12, width: 50, height: 50)
        
        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: submitButton.leadingAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8)
        
        setupLineSeparatorView()
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    fileprivate func setupLineSeparatorView() {
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.rgb(230, 230, 230)
        addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: topAnchor, left: leadingAnchor, right: trailingAnchor, height: 0.5)
    }
    
    @objc func handleSubmit() {
        guard let commentText = commentTextView.text else { return }
        delegate?.didSubmit(for: commentText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
