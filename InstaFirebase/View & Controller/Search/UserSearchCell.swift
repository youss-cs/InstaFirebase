//
//  UserSearchCell.swift
//  InstaFirebase
//
//  Created by YouSS on 12/11/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import UIKit

class UserSearchCell: UITableViewCell {
    
    let avatarImageView: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .red
        return image
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
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
        contentView.addSubview(usernameLabel)
        
        avatarImageView.anchor(left: contentView.leadingAnchor, paddingLeft: 8, width: 50, height: 50)
        avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        avatarImageView.layer.cornerRadius = 50 / 2
        usernameLabel.anchor(top: contentView.topAnchor, left: avatarImageView.trailingAnchor, bottom: contentView.bottomAnchor, right: contentView.trailingAnchor, paddingLeft: 8, paddingRight: 8)
    }
}
