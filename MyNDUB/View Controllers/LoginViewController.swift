//
//  LoginViewController.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-07-21.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "LoginBackground")
        imageView.alpha = 0.7
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Login"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 50)
        return label
    }()
    
    let emailTextField: inputTextField = {
        let textField = inputTextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        return textField
    }()
    
    let passwordTextField: inputTextField = {
        let textField = inputTextField()
        textField.isSecureTextEntry = true
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        return textField
    }()
    
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(LoginViewController.dismissVC), for: .touchDown)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        view.addSubview(backgroundImage)
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(backButton)
        view.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(LoginViewController.handleLogin), for: .touchDown)
        
        setup()
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleLogin() {
        guard let email = self.emailTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error)
            } else {
                globalVars.accountInfo = Account(profileImage: UIImage(named: "cuteOwl")!, name: "", email: self.emailTextField.text!)
                NSKeyedArchiver.archiveRootObject(globalVars.accountInfo, toFile: self.accountFilePath)
                self.performSegue(withIdentifier: "toHome", sender: self)
            }
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func setup() {
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        
        emailTextField.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8).isActive = true
        emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        passwordTextField.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        backButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.3).isActive = true
        backButton.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 10).isActive = true
        backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        doneButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.3).isActive = true
        doneButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

}

extension LoginViewController {
    var accountFilePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        
        return url!.appendingPathComponent("AccountData").path
    }
}

class inputTextField: UITextField {
    override func didMoveToWindow() {
        self.textColor = .white
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.white.cgColor
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.layer.borderWidth = 2.0
        self.autocapitalizationType = .none
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
