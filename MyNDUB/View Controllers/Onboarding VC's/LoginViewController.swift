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
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Login"
        label.textAlignment = .center
        label.textColor = .orange
        label.font = UIFont.boldSystemFont(ofSize: 50)
        return label
    }()
    
    let emailTextField: inputTextField = {
        let textField = inputTextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        return textField
    }()
    
    let passwordTextField: inputTextField = {
        let textField = inputTextField()
        textField.isSecureTextEntry = true
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        return textField
    }()
    
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .orange
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
        button.backgroundColor = .orange
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(LoginViewController.dismissVC), for: .touchDown)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    let continueWithoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue without account", for: .normal)
        button.addTarget(self, action: #selector(LoginViewController.handleContinueWithout), for: .touchDown)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.gray, for: .normal)
        return button
    }()
    
    var origin: CGPoint?

    var isConnectedToInternet = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                print("Connected")
                self.isConnectedToInternet = true
            }
        })
        
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(backButton)
        view.addSubview(doneButton)
        view.addSubview(continueWithoutButton)
        doneButton.addTarget(self, action: #selector(LoginViewController.handleDone), for: .touchDown)
        

        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        setup()
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let info = notification.userInfo {
            
            let rect: CGRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
            
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
                self.backButton.frame.origin.y = (self.view.frame.height - rect.height - self.backButton.frame.height - 10)
                self.doneButton.frame.origin.y = (self.backButton.frame.origin.y - self.doneButton.frame.height - 10)
                self.continueWithoutButton.frame.origin.y = (self.doneButton.frame.origin.y - self.continueWithoutButton.frame.height - 10)
                self.passwordTextField.frame.origin.y = (self.doneButton.frame.origin.y - self.passwordTextField.frame.height - 10)
                self.emailTextField.frame.origin.y = (self.passwordTextField.frame.origin.y - self.emailTextField.frame.height - 10)
                self.titleLabel.frame.origin.y = (self.emailTextField.frame.origin.y - self.titleLabel.frame.height - 10)

            }
        }
    }
    
    @objc func handleDone() {
        if isConnectedToInternet {
            handleLogin()
        } else {
            let alertVC = UIAlertController(title: "Connection Failure", message: "You are not currently connected to a network. Please reconnect before you change your courses.", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @objc func handleLogin() {
        guard let email = self.emailTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                globalVars.accountInfo = Account(profileImage: UIImage(named: "cuteOwl")!, name: "", email: self.emailTextField.text!)
                //UserDefaults.setValue(email, forKey: "email")
                NSKeyedArchiver.archiveRootObject(globalVars.accountInfo, toFile: self.accountFilePath)
                self.performSegue(withIdentifier: "toHome", sender: self)
            }
        }
        

    }
    
    @objc func handleContinueWithout() {
        globalVars.hasAccount = false
        self.performSegue(withIdentifier: "toHome", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func setup() {
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -30).isActive = true
        
        emailTextField.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8).isActive = true
        emailTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -10).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        passwordTextField.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8).isActive = true
        passwordTextField.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -50).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        continueWithoutButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.5).isActive = true
        continueWithoutButton.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -10).isActive = true
        continueWithoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        continueWithoutButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        doneButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.5).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -10).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        backButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.5).isActive = true
        backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.bounds.height/3)).isActive = true
        backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        
    }
    
    override open var shouldAutorotate: Bool {
        return false
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
        self.textColor = .orange
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.orange.cgColor
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.layer.borderWidth = 2.0
        self.autocapitalizationType = .none
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
