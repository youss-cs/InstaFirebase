//
//  SignUpController.swift
//  InstaFirebase
//
//  Created by YouSS on 12/5/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController {
    
    let photoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePhoto), for: .touchUpInside)
        return button
    }()
    
    let emailField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.font = UIFont.boldSystemFont(ofSize: 14)
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let usernameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.font = UIFont.boldSystemFont(ofSize: 14)
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.font = UIFont.boldSystemFont(ofSize: 14)
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Signup", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor.rgb(149, 204, 244)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        return button
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedString = NSMutableAttributedString(string: "Already have an account?  " , attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor : UIColor.lightGray])
        attributedString.append(NSAttributedString(string: "Sign In", attributes: [.font : UIFont.boldSystemFont(ofSize: 14), .foregroundColor : UIColor.rgb(17, 154, 237)]))
        
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    func setupView() {
        view.backgroundColor = .white
        view.addSubview(photoButton)
        view.addSubview(alreadyHaveAccountButton)
        
        alreadyHaveAccountButton.anchor(left: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.trailingAnchor, height: 50)
        photoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 40, width: 140, height: 140)
        photoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputFields()
    }
    
    func setupInputFields() {
        let inputStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [emailField, usernameField, passwordField, signupButton])
            stack.distribution = .fillEqually
            stack.axis = .vertical
            stack.spacing = 10
            return stack
        }()
        
        view.addSubview(inputStack)
        inputStack.anchor(top: photoButton.bottomAnchor, left: view.safeAreaLayoutGuide.leadingAnchor, right: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 40, paddingLeft: 30, paddingRight: 30, height: 200)
    }
    
    @objc func handleTextInputChange() {
        let isValidForm = emailField.text?.count ?? 0 > 0 && usernameField.text?.count ?? 0 > 0 && passwordField.text?.count ?? 0 > 0
        signupButton.isEnabled = isValidForm
        signupButton.backgroundColor = isValidForm ? UIColor.rgb(17, 154, 237) : UIColor.rgb(149, 204, 244)
    }
    
    @objc func handleSignup() {
        guard let email = emailField.text?.lowercased(), email.count > 0 else { return }
        guard let username = usernameField.text, username.count > 0 else { return }
        guard let password = passwordField.text, password.count > 0 else { return }
        
        AuthService.instance.registerUserWith(email: email, password: password, username: username, image: photoButton.imageView?.image) { (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            UIApplication.setRootView(MainTabBarController())
        }
    }
    
    @objc func handlePhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleShowLogin() {
        _ = navigationController?.popViewController(animated: true)
    }
}

extension SignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            photoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        photoButton.layer.cornerRadius = photoButton.frame.width / 2
        photoButton.layer.borderColor = UIColor.black.cgColor
        photoButton.layer.borderWidth = 3
        photoButton.clipsToBounds = true
        
        dismiss(animated: true, completion: nil)
    }
}

