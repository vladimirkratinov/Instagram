//
//  SignInViewController.swift
//  Instagram
//
//  Created by Vladimir Kratinov on 2023-02-22.
//

import UIKit
import SafariServices

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    //Subviews
    private let headerView = SignInHeaderView()
    
    private let emailField: IGTextField = {
       let field = IGTextField()
        field.placeholder = "Email Address"
        field.keyboardType = .emailAddress
        field.returnKeyType = .next
        field.autocorrectionType = .no
        return field
    }()
    
    private let passwordField: IGTextField = {
       let field = IGTextField()
        field.placeholder = "Password"
        field.isSecureTextEntry = true
        field.keyboardType = .default
        field.returnKeyType = .continue
        field.autocorrectionType = .no
        return field
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    private let termsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.setTitle("Terms of Service", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 14)
//        button.layer.borderWidth = 5
        return button
    }()
    
    private let privacyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.setTitle("Privacy Policy", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 14)
//        button.layer.borderWidth = 5
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        
        addSubviews()
        
        emailField.delegate = self
        passwordField.delegate = self
        
        addButtonActions()
        
        // Testing User model as a dictionary:
//        let user = User(username: "wizardexiles", email: "wizardexiles@gmail.com")
//        print(user.asDictionary())
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.width,
            height: (view.height - view.safeAreaInsets.top)/3 - 50
        )
        
        emailField.frame = CGRect(x: 25, y: headerView.bottom+20, width: view.width-50, height: 50)
        passwordField.frame = CGRect(x: 25, y: emailField.bottom+10, width: view.width-50, height: 50)
        signInButton.frame = CGRect(x: 35, y: passwordField.bottom+20, width: view.width-70, height: 50)
        createAccountButton.frame = CGRect(x: 35, y: signInButton.bottom+10, width: view.width-70, height: 50)
        termsButton.frame = CGRect(x: 35, y: createAccountButton.bottom+120, width: view.width-70, height: 50)
        privacyButton.frame = CGRect(x: 35, y: termsButton.bottom+0, width: view.width-70, height: 50)
    }
    
    private func addSubviews() {
        view.addSubview(headerView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(createAccountButton)
        view.addSubview(termsButton)
        view.addSubview(privacyButton)
    }
    
    private func addButtonActions() {
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTerms), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(didTapPrivacy), for: .touchUpInside)
    }
    
    private func showAlert(withTitle title: String?, message: String?, viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Actions
    
    @objc func didTapSignIn() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        //        guard let email = emailField.text,
        //              let password = passwordField.text,
        //              !email.trimmingCharacters(in: .whitespaces).isEmpty,
        //              !password.trimmingCharacters(in: .whitespaces).isEmpty,
        //              password.count >= 6 else {
        //            return
        //        }
        
        guard let email = emailField.text,
              let password = passwordField.text else {
            return
        }
        
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(withTitle: "Error", message: "Email field is empty", viewController: self)
            print("Email field is empty")
            return
        }
        
        guard !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(withTitle: "Error", message: "Password field is empty", viewController: self)
            print("Password field is empty")
            return
        }
        
        // Sign In with AuthManager
        AuthManager.shared.signIn(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    let vc = TabBarViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true)
                    
                case .failure:
                    DatabaseManager.shared.findUser(with: email) { user in
                        if user?.email != email {
                            self?.showAlert(withTitle: "Error", message: "Wrong Email", viewController: self!)
                            print("Wrong Email")
                            self?.passwordField.text = nil
                        } else {
                            self?.showAlert(withTitle: "Error", message: "Wrong Password", viewController: self!)
                            print("Wrong Password")
                            self?.passwordField.text = nil
                        }
                    }
                }
            }
        }
    }
    
    @objc func didTapCreateAccount() {
        let vc = SignUpViewController()
        vc.completion = {
            DispatchQueue.main.async { [weak self] in
                let tabVC = TabBarViewController()
                tabVC.modalPresentationStyle = .fullScreen
                self?.present(tabVC, animated: true)
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapTerms() {
        guard let url = URL(string: "https://help.instagram.com/581066165581870") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc func didTapPrivacy() {
        guard let url = URL(string: "https://help.instagram.com/155833707900388") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    //MARK: - Field Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            didTapSignIn()
        }
        return true
    }
}
