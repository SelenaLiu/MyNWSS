//
//  SignUpViewController.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-07-27.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
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
        label.text = "Sign Up"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 50)
        return label
    }()
    
    let nameTextField: inputTextField = {
        let textField = inputTextField()
        textField.attributedPlaceholder = NSAttributedString(string: "First and Last Name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        return textField
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
        button.addTarget(self, action: #selector(SignUpViewController.dismissVC), for: .touchDown)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()
        view.backgroundColor = .orange
        view.addSubview(backgroundImage)
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(doneButton)
        view.addSubview(backButton)
        doneButton.addTarget(self, action: #selector(SignUpViewController.handleRegister), for: .touchDown)
        
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func handleRegister() {
        guard let email = self.emailTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
        guard let name = self.nameTextField.text else { return }
            
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error)
            } else {
                print("User created!")
                globalVars.accountInfo = Account(profileImage: UIImage(named: "cuteOwl")!, name: self.nameTextField.text!, email: self.emailTextField.text!)
                NSKeyedArchiver.archiveRootObject(globalVars.accountInfo, toFile: self.accountFilePath)
                self.performSegue(withIdentifier: "toHome", sender: self)
            }
        }
        
        
    }
    
    func setup() {
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        
        nameTextField.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8).isActive = true
        nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        emailTextField.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10).isActive = true
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

extension SignUpViewController {
    var accountFilePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        
        return url!.appendingPathComponent("AccountData").path
    }
}
