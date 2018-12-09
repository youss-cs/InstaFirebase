//
//  CustomImageView.swift
//  InstaFirebase
//
//  Created by YouSS on 12/9/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    var lastImageURL: String?
    
    func loadImage(imageUrl: String) {
        lastImageURL = imageUrl
        guard let url = URL(string: imageUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error { print("Failed to retrieve image", error) }
            guard let data = data else { return }
            if url.absoluteString != self.lastImageURL { return }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}
