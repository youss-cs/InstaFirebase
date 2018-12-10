//
//  HomePostCell.swift
//  InstaFirebase
//
//  Created by YouSS on 12/10/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import UIKit

class HomePostCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            guard let imageUrl = post?.imageUrl else { return }
            photoImageView.loadImage(imageUrl: imageUrl)
        }
    }
    
    let photoImageView: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leadingAnchor, bottom: bottomAnchor, right: trailingAnchor)
    }
}
