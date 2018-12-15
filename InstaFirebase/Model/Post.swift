//
//  Post.swift
//  InstaFirebase
//
//  Created by YouSS on 12/9/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import Foundation
import Firebase

struct Post {
    let id: String?
    let imageUrl: String
    let caption: String
    let imageWidth: CGFloat
    let imageHeight: CGFloat
    let createdAt: Date
    var hasLiked = false
    let user: User
    
    
    var dictionary: [String : Any] {
        var dic: [String: Any] = [
            kIMAGEURL : imageUrl,
            kCAPTION : caption,
            kIMAGEWIDTH : imageWidth,
            kIMAGEHEIGHT : imageHeight,
            kCREATEDAT : createdAt,
            kUSERID : user.id
        ]
        
        if let id = id { dic[kID] = id }
        return dic
    }
    
    init?(user: User, dictionary: [String : Any]) {
        guard let _imageUrl = dictionary[kIMAGEURL] as? String,
            let _caption = dictionary[kCAPTION] as? String,
            let _imageWidth = dictionary[kIMAGEWIDTH] as? CGFloat,
            let _imageHeight = dictionary[kIMAGEHEIGHT] as? CGFloat
            else {
                return nil
        }
        
        id = dictionary[kID] as? String ?? nil
        imageUrl = _imageUrl
        caption = _caption
        imageWidth = _imageWidth
        imageHeight = _imageHeight
        self.user = user
        
        if let _createdAt = dictionary[kCREATEDAT] as? Timestamp {
            createdAt = _createdAt.dateValue()
        } else if let _createdAt = dictionary[kCREATEDAT] as? Date {
            createdAt = _createdAt
        } else {
            return nil
        }
    }
}
