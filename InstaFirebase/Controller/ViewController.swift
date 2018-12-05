//
//  ViewController.swift
//  InstaFirebase
//
//  Created by YouSS on 12/5/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let photoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let emailField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.font = UIFont.boldSystemFont(ofSize: 14)
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let usernameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.font = UIFont.boldSystemFont(ofSize: 14)
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.font = UIFont.boldSystemFont(ofSize: 14)
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Signup", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor.rgb(149, 204, 244)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    func setupView() {
        view.addSubview(photoButton)
        
        photoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
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
        inputStack.anchor(top: photoButton.bottomAnchor, left: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, right: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 40, paddingLeft: 20, paddingBottom: 0, paddingRight: -20, width: 0, height: 200)
    }

}

