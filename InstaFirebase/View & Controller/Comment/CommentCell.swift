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
            txtLabel.text = comment.text
        }
    }
    
    let avatarImageView: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let txtLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
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
        contentView.addSubview(txtLabel)
        avatarImageView.anchor(left: contentView.leadingAnchor, paddingLeft: 8, width: 50, height: 50)
        avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        avatarImageView.layer.cornerRadius = 50 / 2
        txtLabel.anchor(top: avatarImageView.topAnchor, left: avatarImageView.trailingAnchor, bottom: nil,  right: trailingAnchor, paddingLeft: 8, paddingRight: 8)
    }
}
