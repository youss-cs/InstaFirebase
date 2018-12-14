//
//  CommentCell.swift
//  InstaFirebase
//
//  Created by YouSS on 12/14/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    var comment: Comment? {
        didSet {
            guard let comment = comment else { return }
            avatarImageView.loadImage(imageUrl: comment.user.profileImage)
            
            let attributedText = NSMutableAttributedString(string: comment.user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            
            attributedText.append(NSAttributedString(string: " " + comment.text, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            
            textView.attributedText = attributedText
        }
    }
    
    let avatarImageView: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(textView)
        
        avatarImageView.anchor(top: contentView.topAnchor, left: contentView.leadingAnchor, paddingTop: 8, paddingLeft: 8, width: 40, height: 40)
        avatarImageView.layer.cornerRadius = 40 / 2
        textView.anchor(top: contentView.topAnchor, left: avatarImageView.trailingAnchor, bottom: contentView.bottomAnchor,  right: contentView.trailingAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4)
        let textViewGreatOrEqual = textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 48)
        textViewGreatOrEqual.priority = .defaultHigh
        textViewGreatOrEqual.isActive = true
    }
}
