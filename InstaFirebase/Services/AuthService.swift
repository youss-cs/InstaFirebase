//
//  AuthService.swift
//  Swiford
//
//  Created by OuSS on 10/31/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    
    static let instance = AuthService()
    
    //MARK: Returning current user funcs
    
    func currentUser() -> User? {
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) as? [String : Any] {
                return User(dictionary: dictionary)
            }
        }
        return nil
    }
    
    //MARK: Login function
    
    func loginUserWith(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (firUser, error) in
            
            if error != nil {
                completion(error)
                return
            } else {
                //get user from firebase and save locally
                self.fetchUser(userId: firUser!.user.uid, completion: { (user) in
                    self.saveUserLocally(user: user)
                    completion(nil)
                })
            }
        })
    }
    
    //MARK: Register functions
    
    func registerUserWith(email: String, password: String, username: String, image: UIImage?, completion: @escaping (_ error: Error?) -> Void ) {
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) in
            if error != nil {
                completion(error)
                return
            }
            
            guard let fuser = result?.user else {
                completion(error)
                return
            }
            
            var dict: [String : Any] = [kID : fuser.uid, kEMAIL : fuser.email!, kUSERNAME : username]
            
            guard let image = image else {
                self.saveUser(dictionary: dict)
                completion(nil)
                return
            }
            
            StorageService.instance.uploadImage(image: image, path: kPROFILE, completion: { (imageURL) in
                if let imageURL = imageURL {
                    dict[kPROFILEIMAGEURL] = imageURL
                    self.saveUser(dictionary: dict)
                }
                completion(nil)
            })
        })
    }
    
    //MARK: LogOut func
    
     func logOutCurrentUser(completion: @escaping (_ success: Bool) -> Void) {
        userDefaults.removeObject(forKey: kCURRENTUSER)
        userDefaults.synchronize()
        
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch let error as NSError {
            completion(false)
            print(error.localizedDescription)
        }
    }
    
    //MARK: Delete user
    
    func deleteUser(completion: @escaping (_ error: Error?) -> Void) {
        let user = Auth.auth().currentUser
        user?.delete(completion: { (error) in
            completion(error)
        })
    }
    
    //MARK: Save user funcs
    
    func saveUserToFirestore(user: User) {
        reference(.Users).document(user.id).setData(user.dictionary) { (error) in
            print("error is \(String(describing: error?.localizedDescription))")
        }
    }
    
    func saveUserLocally(user: User) {
        UserDefaults.standard.set(user.dictionary, forKey: kCURRENTUSER)
        UserDefaults.standard.synchronize()
    }
    
    func saveUser(dictionary:[String : Any]) {
        let user = User(dictionary: dictionary)
        self.saveUserToFirestore(user: user)
        self.saveUserLocally(user: user)
    }
    
    //MARK: Fetch User funcs
    
    func fetchUser(userId: String, completion: @escaping (_ user: User) -> Void) {
        reference(.Users).document(userId).getDocument { (document, error) in
            guard let document = document, document.exists else { return }
            guard let dictionary = document.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    func fetchUsers(completion: @escaping (_ users: [User]) -> Void) {
        var users = [User]()
        reference(.Users).order(by: "username").getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            for document in snapshot.documents {
                let user = User(dictionary: document.dataWithId())
                users.append(user)
            }
            completion(users)
        }
    }
}
