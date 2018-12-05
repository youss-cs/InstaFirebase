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
    
    func currentId() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    func currentUser() -> User? {
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) as? [String : Any] {
                //return User(dictionary: dictionary)
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
                //self.fetchCurrentUserFromFirestore(objectId: firUser!.user.uid) {
                    completion(error)
                //}
            }
        })
    }
    
    //MARK: Register functions
    
    func registerUserWith(email: String, password: String, username: String, completion: @escaping (_ error: Error?) -> Void ) {
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (firuser, error) in
            if error != nil {
                completion(error)
                return
            }
            
            /*let user = User(objectId: firuser!.user.uid, createdAt: Date(), updatedAt: Date(), email: firuser!.user.email!, username: username)
            
            self.saveUserLocally(user: user)
            self.saveUserToFirestore(user: user)*/
            completion(error)
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
    
    /*func saveUserToFirestore(user: User) {
        reference(.Users).document(user.objectId).setData(user.dictionary) { (error) in
            print("error is \(String(describing: error?.localizedDescription))")
        }
    }
    
    func saveUserLocally(user: User) {
        UserDefaults.standard.set(user.dictionary, forKey: kCURRENTUSER)
        UserDefaults.standard.synchronize()
    }
    
    //MARK: Fetch User funcs
    
    func fetchCurrentUserFromFirestore(objectId: String, completion: @escaping () -> Void) {
        reference(.Users).document(objectId).getDocument { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            if snapshot.exists {
                print("updated current users param")
                UserDefaults.standard.setValue(snapshot.data(), forKeyPath: kCURRENTUSER)
                UserDefaults.standard.synchronize()
                completion()
            }
        }
    }*/
}
