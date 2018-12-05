//
//  User.swift
//  InstaFirebase
//
//  Created by YouSS on 12/5/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import Foundation

struct User {
    let id: String
    let email: String
    let username: String
    let profileImage: String
    
    var dictionary: [String : Any] {
        return [
            kID : id,
            kEMAIL : email,
            kUSERNAME : username,
            kPROFILE : profileImage
        ]
    }
    
    init(dictionary: [String : Any]) {
        id = dictionary[kID] as! String
        email = dictionary[kEMAIL] as? String ?? ""
        username = dictionary[kUSERNAME] as? String ?? ""
        profileImage = dictionary[kPROFILE] as? String ?? ""
    }
}
