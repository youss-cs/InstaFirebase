//
//  HomePostCell.swift
//  InstaFirebase
//
//  Created by YouSS on 12/10/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import UIKit

protocol HomePostCellDelegate {
    func didTapComment(post: Post)
}

class HomePostCell: UICollectionViewCell {
    
    var delegate: HomePostCellDelegate?
    
    var post: Post? {
        didSet {
            guard let imageUrl = post?.imageUrl else { return }
            photoImageView.loadImage(imageUrl: imageUrl)
            guard let profileImage = post?.user.profileImage else { return }
            avatarImageView.loadImage(imageUrl: profileImage)
            usernameLabel.text = post?.user.username
            setupAttributedCaption()
        }
    }
    
    let avatarImageView: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .blue
        return image
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    let photoImageView: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let likeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    lazy var commentButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return button
    }()
    
    let shareButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let bookmarkButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        addSubview(optionsButton)
        addSubview(photoImageView)
        addSubview(likeButton)
        addSubview(shareButton)
        addSubview(commentButton)
        addSubview(captionLabel)
        
        avatarImageView.anchor(top: topAnchor, left: leadingAnchor, paddingTop: 8, paddingLeft: 8, width: 40, height: 40)
        avatarImageView.layer.cornerRadius = 40 / 2
        usernameLabel.anchor(top: topAnchor, left: avatarImageView.trailingAnchor, bottom: photoImageView.topAnchor,  right: trailingAnchor, paddingLeft: 8)
        optionsButton.anchor(top: usernameLabel.topAnchor, bottom: usernameLabel.bottomAnchor, right: trailingAnchor, width: 44)
        photoImageView.anchor(top: avatarImageView.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 8)
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        setupActionButtons()
        
        captionLabel.anchor(top: likeButton.bottomAnchor, left: leadingAnchor, bottom: bottomAnchor, right: trailingAnchor, paddingLeft: 8, paddingRight: 8)
    }
    
    func setupActionButtons() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        addSubview(bookmarkButton)
        
        stackView.anchor(top: photoImageView.bottomAnchor, left: leadingAnchor, paddingLeft: 4, width: 120, height: 50)
        bookmarkButton.anchor(top: photoImageView.bottomAnchor, right: trailingAnchor, width: 40, height: 50)
    }
    
    fileprivate func setupAttributedCaption() {
        guard let post = post else { return }
        
        let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
        
        let timeAgo = post.createdAt.timeAgoDisplay()
        attributedText.append(NSAttributedString(string: timeAgo, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        
        captionLabel.attributedText = attributedText
    }
    
    @objc func handleComment() {
        guard let post = post else { return }
        delegate?.didTapComment(post: post)
    }
}
