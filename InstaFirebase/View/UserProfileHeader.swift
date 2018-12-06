//
//  UserProfileHeader.swift
//  InstaFirebase
//
//  Created by YouSS on 12/6/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import UIKit

class UserProfileHeader: UICollectionViewCell {
    
    let avatarImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    var user: User? {
        didSet {
            guard let imageUrl = user?.profileImage else { return }
            setupProfileImage(imageUrl: imageUrl)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(avatarImage)
        avatarImage.anchor(top: safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leadingAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        avatarImage.layer.cornerRadius = 80 / 2
        avatarImage.clipsToBounds = true
    }
    
    func setupProfileImage(imageUrl: String) {
        guard let url = URL(string: imageUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error { print("Failed to retrieve image", error) }
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                self.avatarImage.image = UIImage(data: data)
            }
        }.resume()
    }
}
