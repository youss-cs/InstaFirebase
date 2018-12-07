//
//  LoginController.swift
//  InstaFirebase
//
//  Created by YouSS on 12/7/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    let logoContainerView: UIView = {
        let view = UIView()
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        imageView.anchor(width: 200, height: 50)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.backgroundColor = UIColor.rgb(0, 120, 175)
        return view
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
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor.rgb(149, 204, 244)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedString = NSMutableAttributedString(string: "Don't have an account? " , attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor : UIColor.lightGray])
        attributedString.append(NSAttributedString(string: "Sign Up", attributes: [.font : UIFont.boldSystemFont(ofSize: 14), .foregroundColor : UIColor.rgb(17, 154, 237)]))
        
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    @objc func handleShowSignUp() {
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    fileprivate func setupView() {
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(logoContainerView)
        view.addSubview(dontHaveAccountButton)
        view.backgroundColor = .white
        
        dontHaveAccountButton.anchor(left: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.trailingAnchor, height: 50)
        logoContainerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, right: view.trailingAnchor, height: 150)
        
        setupInputFields()
    }
    
    func setupInputFields() {
        let inputStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [emailField, passwordField, loginButton])
            stack.distribution = .fillEqually
            stack.axis = .vertical
            stack.spacing = 10
            return stack
        }()
        
        view.addSubview(inputStack)
        inputStack.anchor(top: logoContainerView.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 40, paddingLeft: 30, paddingRight: 30, height: 140)
    }
    
    @objc func handleTextInputChange() {
        let isValidForm = emailField.text?.count ?? 0 > 0 && passwordField.text?.count ?? 0 > 0
        loginButton.isEnabled = isValidForm
        loginButton.backgroundColor = isValidForm ? UIColor.rgb(17, 154, 237) : UIColor.rgb(149, 204, 244)
    }
    
    @objc func handleLogin() {
        guard let email = emailField.text?.lowercased(), email.count > 0 else { return }
        guard let password = passwordField.text, password.count > 0 else { return }
        
        AuthService.instance.loginUserWith(email: email, password: password) { (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            UIApplication.setRootView(MainTabBarController())
        }
    }
}
