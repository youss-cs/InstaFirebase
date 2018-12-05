//
//  StorageService.swift
//  InstaFirebase
//
//  Created by YouSS on 12/5/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageService {
    
    static let instance = StorageService()
    private let reference = Storage.storage().reference()
    
    func uploadImage(image: UIImage, completion: @escaping (_ url: URL?) -> ()) {
        
        guard let data = image.jpegData(compressionQuality: 0.4) else {
            completion(nil)
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        let storageRef = reference.child("ProfileImages").child(imageName)
        
        storageRef.putData(data, metadata: metadata) { (meta, error) in
            if error != nil {
                completion(nil)
                return
            }
            
            storageRef.downloadURL(completion: { (url, error) in
                guard let downloadURL = url else {
                    completion(nil)
                    return
                }
                
                completion(downloadURL)
            })
        }
        
    }
}
