//
//  LoginViewController.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-07-21.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit

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
        label.text = "Join Us"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 50)
        return label
    }()
    
    let loginRegisterSegment: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.tintColor = .white
        segment.insertSegment(withTitle: "Sign In", at: 0, animated: true)
        segment.insertSegment(withTitle: "Sign Up", at: 1, animated: true)
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.addTarget(self, action: #selector(LoginViewController.handleSegmentControl), for: .valueChanged)
        segment.selectedSegmentIndex = 1
        return segment
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
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        return textField
    }()
    
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(LoginViewController.toHome), for: .touchDown)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    @objc func toHome() {
        performSegue(withIdentifier: "toHome", sender: self)
    }
    
    @objc func handleSegmentControl() {
        if loginRegisterSegment.selectedSegmentIndex == 0 {
            nameTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
            passwordTextField.isHidden = true
        } else {
            nameTextField.attributedPlaceholder = NSAttributedString(string: "First and Last Name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
            passwordTextField.isHidden = false

        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        view.addSubview(backgroundImage)
        view.addSubview(titleLabel)
        view.addSubview(loginRegisterSegment)
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(doneButton)
        
        setup()
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
        
        loginRegisterSegment.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8).isActive = true
        loginRegisterSegment.heightAnchor.constraint(equalToConstant: 35).isActive = true
        loginRegisterSegment.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        loginRegisterSegment.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        nameTextField.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8).isActive = true
        nameTextField.topAnchor.constraint(equalTo: loginRegisterSegment.bottomAnchor, constant: 10).isActive = true
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
        
        doneButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.3).isActive = true
        doneButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

}

class inputTextField: UITextField {
    override func didMoveToWindow() {
        self.isSecureTextEntry = true
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
