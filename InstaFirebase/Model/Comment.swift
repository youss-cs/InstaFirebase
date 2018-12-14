//
//  Comment.swift
//  InstaFirebase
//
//  Created by YouSS on 12/14/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import Foundation
import Firebase

struct Comment {
    //let id: String?
    let text: String
    let postId: String
    let createdAt: Date
    let user: User
    
    var dictionary: [String : Any] {
        let dict: [String : Any] = [
            kTEXT : text,
            kPOSTID : postId,
            kCREATEDAT : createdAt,
            kUSERID : user.id,
        ]
        
        /*if let id = id {
         dict[kID] = id
         }*/
        
        return dict
    }
    
    
    init?(dictionary: [String : Any], user: User) {
        guard let text = dictionary[kTEXT] as? String,
            let postId = dictionary[kPOSTID] as? String else {
                return nil
        }
        
        self.text = text
        self.postId = postId
        self.user = user
        
        if let createdAt = dictionary[kCREATEDAT] as? Timestamp {
            self.createdAt = createdAt.dateValue()
        } else if let createdAt = dictionary[kCREATEDAT] as? Date {
           self.createdAt = createdAt
        } else {
            return nil
        }
    }
}

